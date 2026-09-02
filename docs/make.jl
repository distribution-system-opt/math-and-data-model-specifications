using Documenter

# This is a documentation-only repository: the pages under `src/spec/` are plain
# Markdown, so `makedocs` runs without any `modules`. The home page links to the
# generated PDF (produced only by the LaTeX build), so `warnonly` downgrades that
# unresolved link to a warning rather than failing the HTML-only build.

# ---------------------------------------------------------------------------
# Shared configuration
# ---------------------------------------------------------------------------

const PAGES = [
    "Home"                              => "index.md",
    "Foundations" => [
        "Overview"                      => "spec/index.md",
        "Background & scope"            => "spec/scope.md",
        "Notation"                      => "spec/notation.md",
        "Data input formatting"         => "spec/data-format.md",
        "Grounding"                     => "spec/grounding.md",
        "Worked example"                => "spec/example.md",
        "Document metadata"             => "spec/metadata.md",
    ],
    "Components" => [
        "Buses"                         => "spec/bus.md",
        "Lines"                         => "spec/line.md",
        "Switches"                      => "spec/switch.md",
        "Loads"                         => "spec/load.md",
        "Generators"                    => "spec/generator.md",
        "Shunts"                        => "spec/shunt.md",
        "Capacitors"                    => "spec/capacitor.md",
        "Voltage sources"               => "spec/source.md",
        "Transformers"                  => "spec/transformer.md",
    ],
    "Objective & feasibility"           => "spec/objective.md",
    "Reference" => [
        "Modelling notes & FAQ"         => "spec/faq.md",
        "Nomenclature"                  => "spec/nomenclature.md",
        "References"                    => "spec/references.md",
        "Glossary"                      => "glossary.md",
    ],
    "Project" => [
        "Contributing"                  => "contributing.md",
        "Changelog"                     => "changelog.md",
    ],
]

# Sections that document the project/site itself rather than the specification;
# excluded from the printed PDF so it reads as a clean standalone document.
const PDF_EXCLUDED_SECTIONS = ["Project"]

pdf_pages() = filter(p -> !(p isa Pair && first(p) in PDF_EXCLUDED_SECTIONS), PAGES)

const SITENAME = "Distribution System Model and Data Specification"
const AUTHORS  = "IEEE Task Force on Benchmarking Multiconductor OPF for Distribution Systems"

# Build the PDF whenever we're on CI, or locally when DOCS_PDF=true is set.
const BUILD_PDF = get(ENV, "CI", nothing) == "true" || get(ENV, "DOCS_PDF", "false") == "true"

# Dependencies only needed for the PDF build; loaded lazily so an HTML-only
# build (the common local case) doesn't pay for them.
if BUILD_PDF
    import tectonic_jll
    import Rsvg
    import Cairo
end

# ---------------------------------------------------------------------------
# HTML build
# ---------------------------------------------------------------------------

function make_html()
    makedocs(
        sitename = SITENAME,
        authors  = AUTHORS,
        repo     = Documenter.Remotes.GitHub("distribution-system-opt", "math-and-data-model-specifications"),
        format   = Documenter.HTML(
            prettyurls = get(ENV, "CI", nothing) == "true",  # pretty URLs on CI, plain files locally
            edit_link  = "main",
            canonical  = "https://distribution-system-opt.github.io/math-and-data-model-specifications",
            inventory_version = "0.1.0",
            assets     = ["assets/hide-theme-picker.css"],
        ),
        warnonly = [:cross_references, :linkcheck],
        pages    = PAGES,
    )
    return
end

# ---------------------------------------------------------------------------
# PDF build (Documenter's LaTeX backend + tectonic, like JuMP.jl)
#
# tectonic is a self-contained TeX engine shipped as a Julia artifact, so no
# system LaTeX installation is required — on CI or locally it "just works".
# LaTeX/tectonic cannot embed SVG images, so we build from a copy of `src/` in
# which every SVG figure has been rasterised to PDF (via the Rsvg + Cairo JLL
# stack) and the Markdown image links rewritten to point at the PDF.
# ---------------------------------------------------------------------------

function convert_svgs_to_pdf(dir)
    for (root, _, files) in walkdir(dir)
        for f in files
            endswith(f, ".svg") || continue
            svg = joinpath(root, f)
            pdf = svg[1:end-4] * ".pdf"
            handle = Rsvg.handle_new_from_file(svg)
            dims = Rsvg.handle_get_dimensions(handle)
            surface = Cairo.CairoPDFSurface(pdf, dims.width, dims.height)
            ctx = Cairo.CairoContext(surface)
            Rsvg.handle_render_cairo(ctx, handle)
            Cairo.finish(surface)
            rm(svg)
        end
    end
    # Rewrite `.svg` → `.pdf` in every Markdown image/link.
    for (root, _, files) in walkdir(dir)
        for f in files
            endswith(f, ".md") || continue
            path = joinpath(root, f)
            write(path, replace(read(path, String), ".svg" => ".pdf"))
        end
    end
    return
end

function make_latex()
    latex_src   = joinpath(@__DIR__, "latex_src")
    latex_build = joinpath(@__DIR__, "latex_build")
    rm(latex_src; force = true, recursive = true)
    cp(joinpath(@__DIR__, "src"), latex_src)
    convert_svgs_to_pdf(latex_src)
    makedocs(
        sitename = SITENAME,
        authors  = AUTHORS,
        format   = Documenter.LaTeX(
            platform = "tectonic",
            tectonic = tectonic_jll.tectonic(),
        ),
        source   = latex_src,
        build    = latex_build,
        warnonly = true,   # never fail the PDF build over the upstream cross-refs
        pages    = pdf_pages(),
    )
    # Surface the PDF alongside the HTML output so it deploys with the site.
    pdf  = only(filter(f -> endswith(f, ".pdf"), readdir(latex_build; join = true)))
    dest = joinpath(@__DIR__, "build", "DistributionSystemModelSpecification.pdf")
    cp(pdf, dest; force = true)
    rm(latex_src; force = true, recursive = true)
    return
end

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------

make_html()
if BUILD_PDF
    make_latex()
end

deploydocs(
    repo      = "github.com/distribution-system-opt/math-and-data-model-specifications.git",
    devbranch = "main",
    push_preview = true,
)
