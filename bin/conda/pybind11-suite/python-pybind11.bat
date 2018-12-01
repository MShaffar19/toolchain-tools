echo ON

python %RECIPE_DIR%\\move.py --src=%SRC_DIR%\\Library\\lib --dst=%PREFIX%\\Library\\lib
python %RECIPE_DIR%\\move.py --src=%SRC_DIR%\\Library\\bin --dst=%PREFIX%\\Library\\bin

echo OFF