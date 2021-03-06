library model;

/// The grid that will display the game.
class Grid extends Collection{
  final List<List<Cell>> _model;
  int _width;
  int _height;
  
  int get width => _width;
  int get height => _height;
  
  /// Returns the number of cells, which is [height] * [width].
  int get length {
    return width * height; 
  }
  
  /// Not yet implemented.
  Grid map(Function cell) {
  }
  
  /// Not yet implemented.
  Grid filter(Function cell) {
  }
  
  /// Iterates over elements in the grid row by row starting with `[0][0]`,
  /// then `[0][1]`, etc.
  Iterator iterator() => _model.iterator();//new GridIterator(this);
  
  /// Creates a new grid of width [x], and height [y].
  // TODO(amouravski): Make this make sense.
  Grid(width, this._height)
      : _model = new List<List<Cell>>(width),
        _width = width {
    for (List<Cell> x in _model) {
      x = new List<Cell>(this.height);
    }
  }
  
  /// Creates an empty grid.
  Grid.empty()
      :_model = new List(),
      _width = 0,
      _height = 0;
  
  /**
   *  Adds a single column to the grid.
   *  
   *  Returns the y value of this new col.
   */
  int addRow(List<Cell> row) {
    if (row.length == 0) {
      throw new ExpectException('Cannot add a 0 length column.');
    } else if (length == 0) {
      _model.add(row);
      _height = row.length;
      _width = 1;
      return 0;
    } else if (row.length != height) {
      throw new ExpectException('New column length must be {height}');
    } else {
      _model.add(row);
      return _width++;
    }
  }
  
  /**
   *  Adds a single row to the grid.
   *  
   *  Returns the x value of this new col.
   */
  int addCol(List<Cell> col) {
    if (col.length == 0) {
      throw new ExpectException('Cannot add a 0 length row.');
    } else if (length == 0) {
      for (Cell cell in col) {
        _model.add(new List()..add(cell));
      }
      _height = 1;
      _width = col.length;
      return 0;
    } else if (col.length != width) {
      throw new ExpectException('New row length must be {width}');
    } else {
      for (int i = 0; i < width; i++){
        _model[i].add(col[i]);
      }
      return _height++;
    }
  }
  
  /** 
   * Returns the [x]th column.
   * 
   * Best if used with another `[]` to specify the exact `[x][y]` coordinate:
   * 
   *     // Get cell (5, 10)
   *     Cell myCell = myGrid[5][10];
   */
  List<Cell> operator[](int x) {
    return _model[x];
  }

  /// Returns true if the coordinate pair is a valid location on the grid.
  bool _isCellValid(int x, int y) {
    return x > 0 && y > 0 &&
        x < width && y < height &&
        this[x][y].isValid();
  }
  
  
  /**
   * Returns a map of a [cell]'s neighbors keyed on their grid position.
   * 
   * [diagonal] is used to allow neighbors on the diagonal.
   */
  Map<Point, Cell> neighbors(Cell cell, {bool diagonal: false}) {
    var out = new Map<Point, Cell>();
    
    for (int x = cell.x - 1; x < cell.x + 1; x++) {
      for (int y = cell.y - 1; y < cell.y + 1; y++) {
        if (diagonal == false && x == y) {
          continue;
        } else if (_isCellValid(x, y)) {
          out.putIfAbsent(new Point(x, y), () {return this[x][y];});
        }
      }
    }
    
    return out;
  }
  
  /// Returns a list of a [cell]'s neighbors.
  List<Cell> neighborsAsList(Cell cell, {bool diagonal: false}) {
    return neighbors(cell, diagonal: diagonal).values;
  }
}

/// Iterates over elements in the grid row by row starting with `[0][0]`, then
/// `[0][1]`, etc.
class GridIterator extends Iterator {
  final Grid grid;
  int _count = 0;
  
  GridIterator(this.grid);
  
  bool get hasNext => _count < grid.length;
  
  Cell next() => (grid[_count % grid.width][_count ~/ grid.width]);
}

/// One item in the grid.
class Cell {
  final int x;
  final int y;
  
  Cell(this.x, this.y);
  
  /// Override this to allow cell to be skipped as neighbors.
  bool isValid() {
    return true;
  }
}

/// A simple [x], [y] coordinate pair.
class Point {
  final int x;
  final int y;
  
  Point(this.x, this.y);
}