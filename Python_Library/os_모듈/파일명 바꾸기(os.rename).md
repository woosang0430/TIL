## os.rename()
- `os.rename(src, des)`
- src : 변경할 대상 경로파일
- des : 변경할 file명

```python
import os

root = r'C:\Users\yws15\mask_detector_project\without_mask600'

for i, fname in enumerate(os.listdir('without_mask600/')):
  src = os.path.join(root, fname)
  des = os.path.join(root, 'without_mask{0}.jpg'.format(i))
  os.rename(src, des)
```

## 번외. 파일 이동

```python
import shutil
import os

src = r'C:\Users\yws15\mask_detector_project\without_mask600'
des = r'C:\Users\yws15\mask_detector_project\images'

for fname in os.listdir(src)[:1]:
    shutil.move(os.path.join(src, fname), os.path.join(des, fname))
```
