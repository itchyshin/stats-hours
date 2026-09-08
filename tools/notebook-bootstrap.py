"""Prepend the clean-machine bootstrap cell to every notebook under notebooks/ and fix relative paths."""
import json, pathlib
BOOT = pathlib.Path(__file__).with_name("notebook-bootstrap.jl").read_text().replace("{{DRM_REV}}", pathlib.Path(__file__).with_name("engine-pin.txt").read_text().strip())
for p in pathlib.Path("notebooks").glob("*.ipynb"):
    nb = json.loads(p.read_text())
    while nb["cells"] and ("Run this chapter on a clean machine" in "".join(nb["cells"][0]["source"]) or "Cell 2 of 2" in "".join(nb["cells"][0]["source"])):
        nb["cells"].pop(0)
    for i, src in enumerate(BOOT.split("##CELL##\n")):
        nb["cells"].insert(i, {"cell_type": "code", "metadata": {}, "execution_count": None, "outputs": [], "source": src.strip("\n")})
    nb.setdefault("metadata", {})["kernelspec"] = {"name": "julia-1.10", "display_name": "Julia 1.10", "language": "julia"}
    for c in nb["cells"]:
        if c["cell_type"] == "code":
            src = "".join(c["source"]) if isinstance(c["source"], list) else c["source"]
            c["source"] = src.replace('"../tools/', '"tools/').replace('"../data/', '"data/')
    p.write_text(json.dumps(nb, indent=1, ensure_ascii=False))
    print("bootstrapped", p.name)
