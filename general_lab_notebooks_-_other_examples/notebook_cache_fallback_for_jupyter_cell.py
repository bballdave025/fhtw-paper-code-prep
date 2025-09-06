
# Notebook cache fallback (paste at very top)
If your notebook couldn’t see the fallback earlier, here’s the snippet again. Pop this in **before** importing TensorFlow:

```python
# --- CIFAR-10 cache + quieter TF ---
import os, shutil
from pathlib import Path

os.environ.setdefault("TF_CPP_MIN_LOG_LEVEL", "2")
os.environ.setdefault("OMP_NUM_THREADS", "4")
os.environ.setdefault("TF_NUM_INTEROP_THREADS", "2")
os.environ.setdefault("TF_NUM_INTRAOP_THREADS", "4")

tagdir = Path(os.environ.get("TAGDIR", Path.cwd()))
if tagdir.name == "notebooks":
  tagdir = tagdir.parent
os.environ.setdefault("KERAS_HOME", str(tagdir))  # -> $TAGDIR/datasets
proj_cache = Path(os.environ["KERAS_HOME"]) / "datasets"
proj_cache.mkdir(parents=True, exist_ok=True)

home_cache = Path.home() / ".keras" / "datasets"
candidates = [("cifar-10-python.tar.gz", True), ("cifar-10-batches-py", False)]
if home_cache.exists() and not any((proj_cache / name).exists() for name, _ in candidates):
  for name, is_file in candidates:
      src = home_cache / name
      if src.exists():
          dst = proj_cache / src.name
          (shutil.copy2 if is_file else shutil.copytree)(src, dst, dirs_exist_ok=True)

