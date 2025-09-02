import sys
from pathlib import Path
for f in sys.argv[1:]: Path(f).touch(exist_ok=True)

