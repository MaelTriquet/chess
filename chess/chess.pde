float size;
Piece[][] teams = new Piece[2][16];
boolean selecting = false;
Piece selected;
int player = 0;
boolean[] checks = new boolean[2];
PVector[] kings_pos = new PVector[2];
boolean mate = false;
enum Value {
  ROOK, KNIGHT, BISHOP, QUEEN, KING, PAWN
};
void setup() {
  size(800, 800);
  size = min(width, height) / 8;
  initialize_teams();
  surface.setResizable(true);
}

void draw() {
  background(0);
  size = min(width, height) / 8;
  drawBoard();
  for (Piece p : teams[0]) {
    p.show();
    if (p.selected) {
      selected = p;
    }
  }
  for (Piece p : teams[1]) {
    p.show();
    if (p.selected) {
      selected = p;
    }
  }
  if (selected != null) {
    selected.show();
  }
}

void drawBoard() {
  fill(255);
  if (mate) {
    fill(255, 0, 0);
  }
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if ((i+j)%2 == 0) {
        rect(i * size, j * size, size, size);
      }
    }
  }
  if (checks[0]) {
    fill(255, 0, 0);
    rect(kings_pos[0].x * size, kings_pos[0].y * size, size, size); 
  }
  if (checks[1]) {
    fill(255, 0, 0);
    rect(kings_pos[1].x * size, kings_pos[1].y * size, size, size); 
  }
}

void initialize_teams() {
  teams[1][0] = new Piece(0, 0, 1, Value.ROOK);
  teams[1][1] = new Piece(1, 0, 1, Value.KNIGHT);
  teams[1][2] = new Piece(2, 0, 1, Value.BISHOP);
  teams[1][3] = new Piece(3, 0, 1, Value.QUEEN);
  teams[1][4] = new Piece(4, 0, 1, Value.KING);
  teams[1][5] = new Piece(5, 0, 1, Value.BISHOP);
  teams[1][6] = new Piece(6, 0, 1, Value.KNIGHT);
  teams[1][7] = new Piece(7, 0, 1, Value.ROOK);

  teams[1][8] = new Piece(0, 1, 1, Value.PAWN);
  teams[1][9] = new Piece(1, 1, 1, Value.PAWN);
  teams[1][10] = new Piece(2, 1, 1, Value.PAWN);
  teams[1][11] = new Piece(3, 1, 1, Value.PAWN);
  teams[1][12] = new Piece(4, 1, 1, Value.PAWN);
  teams[1][13] = new Piece(5, 1, 1, Value.PAWN);
  teams[1][14] = new Piece(6, 1, 1, Value.PAWN);
  teams[1][15] = new Piece(7, 1, 1, Value.PAWN);

  teams[0][0] = new Piece(0, 7, 0, Value.ROOK);
  teams[0][1] = new Piece(1, 7, 0, Value.KNIGHT);
  teams[0][2] = new Piece(2, 7, 0, Value.BISHOP);
  teams[0][3] = new Piece(3, 7, 0, Value.QUEEN);
  teams[0][4] = new Piece(4, 7, 0, Value.KING);
  teams[0][5] = new Piece(5, 7, 0, Value.BISHOP);
  teams[0][6] = new Piece(6, 7, 0, Value.KNIGHT);
  teams[0][7] = new Piece(7, 7, 0, Value.ROOK);

  teams[0][8] = new Piece(0, 6, 0, Value.PAWN);
  teams[0][9] = new Piece(1, 6, 0, Value.PAWN);
  teams[0][10] = new Piece(2, 6, 0, Value.PAWN);
  teams[0][11] = new Piece(3, 6, 0, Value.PAWN);
  teams[0][12] = new Piece(4, 6, 0, Value.PAWN);
  teams[0][13] = new Piece(5, 6, 0, Value.PAWN);
  teams[0][14] = new Piece(6, 6, 0, Value.PAWN);
  teams[0][15] = new Piece(7, 6, 0, Value.PAWN);
}

void mousePressed() {
  if (!selecting) {
    for (Piece p : teams[player]) {
      if (floor(mouseX/size) == p.pos.x && floor(mouseY/size) == p.pos.y) {
        p.selected = true;
        p.generate_possible_moves(false);
        selecting = true;
        return;
      }
    }
  }
}

void mouseReleased() {
  for (Piece p : teams[0]) {
    if (p.selected) {
      p.release();
      p.selected = false;
      selected = null;
      selecting = false;
      return;
    }
  }
  for (Piece p : teams[1]) {
    if (p.selected) {
      p.release();
      p.selected = false;
      selecting = false;
      selected = null;
      return;
    }
  }
}
