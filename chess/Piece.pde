class Piece {
  PVector pos;
  int team;
  Value value;
  PImage image;
  boolean selected = false;
  PVector prev_pos;
  boolean isDead = false;
  boolean hasMoved = false;
  ArrayList<PVector> possibleMoves = new ArrayList<PVector>();
  boolean pawn_moved_two = false;
  Piece(int x_, int y_, int team_, Value value_) {
    pos = new PVector(x_, y_);
    prev_pos = pos.copy();
    team = team_;
    value = value_;
    if (team == 0) {
      switch (value) {
      case ROOK:
        image = loadImage("tour blanche.png");
        break;
      case KNIGHT:
        image = loadImage("cavalier blanc.png");
        break;
      case BISHOP:
        image = loadImage("fou blanc.png");
        break;
      case QUEEN:
        image = loadImage("dame blanche.png");
        break;
      case KING:
        image = loadImage("roi blanc.png");
        break;
      case PAWN:
        image = loadImage("pion blanc.png");
        break;
      }
    } else {
      switch (value) {
      case ROOK:
        image = loadImage("tour noire.png");
        break;
      case KNIGHT:
        image = loadImage("cavalier noir.png");
        break;
      case BISHOP:
        image = loadImage("fou noir.png");
        break;
      case QUEEN:
        image = loadImage("dame noire.png");
        break;
      case KING:
        image = loadImage("roi noir.png");
        break;
      case PAWN:
        image = loadImage("pion noir.png");
        break;
      }
    }
  }

  void show() {
    image.resize(floor(size), floor(size));
    if (isDead) {
      pos = new PVector(-1, -1);
    }
    if (selected) {
      pos = new PVector(mouseX/size - .5, mouseY/size - .5);
      fill(0, 255, 0);
      for (PVector p : possibleMoves) {
        ellipse(p.x * size + size / 2, p.y * size + size / 2, size/4, size/4);
      }
    }
    if (image != null) {
      image(image, pos.x * size, pos.y * size);
    } else {
      fill(255 * team, 0, 255 * (1-team));
      ellipse(pos.x * size + size / 2, pos.y * size + size / 2, size, size);
    }
  }

  void generate_possible_moves(boolean checking) {
    possibleMoves.clear();
    if (!isDead) {
      switch (value) {
      case ROOK:
        for (int i = 0; i < 8; i++) {
          if (i != pos.x) {
            possibleMoves.add(new PVector(i, pos.y));
          }
          if (i != pos.y) {
            possibleMoves.add(new PVector(pos.x, i));
          }
        }
        break;
      case KNIGHT:
        possibleMoves.add(new PVector(pos.x-1, pos.y-2));
        possibleMoves.add(new PVector(pos.x-1, pos.y+2));
        possibleMoves.add(new PVector(pos.x-2, pos.y-1));
        possibleMoves.add(new PVector(pos.x-2, pos.y+1));
        possibleMoves.add(new PVector(pos.x+1, pos.y-2));
        possibleMoves.add(new PVector(pos.x+1, pos.y+2));
        possibleMoves.add(new PVector(pos.x+2, pos.y-1));
        possibleMoves.add(new PVector(pos.x+2, pos.y+1));
        break;
      case BISHOP:
        for (int i = 1; i < 8; i++) {
          possibleMoves.add(new PVector(pos.x+i, pos.y+i));
          possibleMoves.add(new PVector(pos.x-i, pos.y+i));
          possibleMoves.add(new PVector(pos.x+i, pos.y-i));
          possibleMoves.add(new PVector(pos.x-i, pos.y-i));
        }
        break;
      case QUEEN:
        for (int i = 0; i < 8; i++) {
          if (i != pos.x) {
            possibleMoves.add(new PVector(i, pos.y));
          }
          if (i != pos.y) {
            possibleMoves.add(new PVector(pos.x, i));
          }
        }
        for (int i = 1; i < 8; i++) {
          possibleMoves.add(new PVector(pos.x+i, pos.y+i));
          possibleMoves.add(new PVector(pos.x-i, pos.y+i));
          possibleMoves.add(new PVector(pos.x+i, pos.y-i));
          possibleMoves.add(new PVector(pos.x-i, pos.y-i));
        }
        break;
      case KING:
        possibleMoves.add(new PVector(pos.x-1, pos.y-1));
        possibleMoves.add(new PVector(pos.x-1, pos.y));
        possibleMoves.add(new PVector(pos.x-1, pos.y+1));
        possibleMoves.add(new PVector(pos.x, pos.y-1));
        possibleMoves.add(new PVector(pos.x, pos.y+1));
        possibleMoves.add(new PVector(pos.x+1, pos.y-1));
        possibleMoves.add(new PVector(pos.x+1, pos.y));
        possibleMoves.add(new PVector(pos.x+1, pos.y+1));
        if (!hasMoved && !teams[team][0].hasMoved) {
          boolean someoneBetween = false;
          for (Piece p : teams[1]) {
            if (p.pos.x > 0 && p.pos.x < 4 && p.pos.y == 7 * (1-team)) {
              someoneBetween = true;
            }
          }
          for (Piece p : teams[0]) {
            if (p.pos.x > 0 && p.pos.x < 4 && p.pos.y == 7 * (1-team)) {
              someoneBetween = true;
            }
          }
          if (!someoneBetween) {
            possibleMoves.add(new PVector(pos.x - 2, pos.y));
          }
        }
        if (!hasMoved && !teams[team][7].hasMoved) {
          boolean someoneBetween = false;
          for (Piece p : teams[1]) {
            if (p.pos.x < 7 && p.pos.x > 4 && p.pos.y == 7 * (1-team)) {
              someoneBetween = true;
            }
          }
          for (Piece p : teams[0]) {
            if (p.pos.x < 7 && p.pos.x > 4 && p.pos.y == 7 * (1-team)) {
              someoneBetween = true;
            }
          }
          if (!someoneBetween) {
            possibleMoves.add(new PVector(pos.x + 2, pos.y));
          }
        }
        break;
      case PAWN:
        for (Piece p : teams[1-team]) {
          if (p.pawn_moved_two && pos.y == p.pos.y) {
            p.pos.y -= (p.team-0.5)*2;
          }
        }
        possibleMoves.add(new PVector(pos.x, pos.y + (team-0.5)*2));
        if (team == 0 && pos.y == 6) {
          possibleMoves.add(new PVector(pos.x, pos.y + 2*(team-0.5)*2));
        }
        if (team == 1 && pos.y == 1) {
          possibleMoves.add(new PVector(pos.x, pos.y + 2*(team-0.5)*2));
        }
        for (Piece p : teams[1-team]) {
          if (p.pos.x == pos.x - 1 && p.pos.y == pos.y + (team-0.5)*2) {
            possibleMoves.add(new PVector(pos.x - 1, pos.y + (team-0.5)*2));
          }
          if (p.pos.x == pos.x + 1 && p.pos.y == pos.y + (team-0.5)*2) {
            possibleMoves.add(new PVector(pos.x + 1, pos.y + (team-0.5)*2));
          }
        }
        break;
      }
      for (Piece p : teams[1-team]) {
        if (p.pawn_moved_two) {
          p.pos = p.prev_pos.copy();
        }
      }
      remove_impossible_moves(checking);
    }
  }

  void remove_impossible_moves(boolean checking) {
    for (int i = possibleMoves.size() - 1; i > -1; i--) {
      if (possibleMoves.get(i).x < 0 || possibleMoves.get(i).x > 7 || possibleMoves.get(i).y < 0 || possibleMoves.get(i).y > 7) {
        possibleMoves.remove(i);
      }
    }
    for (int i = possibleMoves.size() - 1; i > -1; i--) {
      PVector move = possibleMoves.get(i).copy();
      for (Piece allie : teams[team]) {
        if (move.x == allie.pos.x && move.y == allie.pos.y) {
          vision_remove(move);
          possibleMoves.get(i).z = 1;
        }
      }
      for (Piece ennemy : teams[1-team]) {
        if (move.x == ennemy.pos.x && move.y == ennemy.pos.y) {
          vision_remove(move);
          if (value == Value.PAWN && move.x == pos.x) {
            possibleMoves.get(i).z = 1;
          }
        }
      }
    }
    if (!checking) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        PVector move = possibleMoves.get(i).copy();
        pos = move.copy();
        eat(false);
        if (isCheck(teams[team][4].pos)) {
          if (value == Value.KING) {
            pos = prev_pos.copy();
            vision_remove(move);
          }
          possibleMoves.get(i).z = 1;
        }
        for (Piece p : teams[1-team]) {
          if (p.pos.x > 7 || p.pos.y > 7) {
            p.pos = p.prev_pos.copy();
            p.isDead = false;
          }
        }
      }
    }

    for (int i = possibleMoves.size() - 1; i > -1; i--) {
      if (possibleMoves.get(i).z == 1) {
        possibleMoves.remove(i);
      }
    }
    pos = prev_pos.copy();
  }

  void vision_remove(PVector move) {
    if (move.x > pos.x && move.y > pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x > move.x && possibleMoves.get(i).y > move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x < pos.x && move.y > pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x < move.x && possibleMoves.get(i).y > move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x > pos.x && move.y < pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x > move.x && possibleMoves.get(i).y < move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x < pos.x && move.y < pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x < move.x && possibleMoves.get(i).y < move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x == pos.x && move.y > pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x == move.x && possibleMoves.get(i).y > move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x == pos.x && move.y < pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x == move.x && possibleMoves.get(i).y < move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x > pos.x && move.y == pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x > move.x && possibleMoves.get(i).y == move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
    if (move.x < pos.x && move.y == pos.y) {
      for (int i = possibleMoves.size() - 1; i > -1; i--) {
        if (possibleMoves.get(i).x < move.x && possibleMoves.get(i).y == move.y) {
          possibleMoves.get(i).z = 1;
        }
      }
    }
  }

  void release() {
    pos = new PVector(floor(mouseX/size), floor(mouseY/size));
    for (PVector p : possibleMoves) {
      if (p.x == pos.x && p.y == pos.y) {
        if (value == Value.KING && pos.x - prev_pos.x == 2) {
          teams[team][7].pos = new PVector(5, 7 * (1-team));
          teams[team][7].prev_pos = new PVector(5, 7 * (1-team));
        }
        if (value == Value.KING && pos.x - prev_pos.x == -2) {
          teams[team][0].pos = new PVector(3, 7 * (1-team));
          teams[team][0].prev_pos = new PVector(3, 7 * (1-team));
        }
        if (value == Value.PAWN && abs(pos.y - prev_pos.y) == 2) {
          pawn_moved_two = true;
        }
        if (value == Value.PAWN && pos.y == 7 * team) {
          value = Value.QUEEN;
          if (team == 0) {
            image = loadImage("dame blanche.png");
          } else {
            image = loadImage("dame noire.png");
          }
          image.resize(floor(size), floor(size));
        }
        prev_pos = pos.copy();
        hasMoved = true;
        eat(true);
        updatePlayer();
        return;
      }
    }
    pos = prev_pos.copy();
  }

  void eat(boolean forReal) {
    for (Piece p : teams[1-team]) {
      if (p.pawn_moved_two && p.pos.y == 4 - p.team) {
        p.pos.y -= (p.team-0.5)*2;
      }
    }
    for (Piece p : teams[1-team]) {
      if (p.pos.x == pos.x && p.pos.y == pos.y) {
        if (!forReal) {
          p.pos = new PVector(8, 8);
        } else {
          p.pos = new PVector(-1, -1);
        }
        p.isDead = true;
      }
    }
    for (Piece p : teams[1-team]) {
      if (p.pawn_moved_two && p.pos.x > -1 && p.pos.x < 8) {
        p.pos = p.prev_pos.copy();
        for (Piece p2 : teams[team]) {
          if (p.pos.x == p2.pos.x && p.pos.y == p2.pos.y) {
            if (!forReal) {
              p.pos = new PVector(8, 8);
            } else {
              p.pos = new PVector(-1, -1);
            }
            p.isDead = true;
          }
        }
      }
    }
  }

  boolean isCheck(PVector spot) {
    for (Piece p : teams[1-team]) {
      p.generate_possible_moves(true);
      for (PVector move : p.possibleMoves) {
        if (move.x == spot.x && move.y == spot.y) {
          return true;
        }
      }
    }
    return false;
  }
}

boolean isCheckmate(int team) {
  for (Piece p : teams[team]) {
    p.generate_possible_moves(false);
    if (p.possibleMoves.size() > 0) {
      return false;
    }
  }
  return true;
}

void updatePlayer() {
  player = 1-player;
  for (Piece p : teams[player]) {
    if (p.pawn_moved_two) {
      p.pawn_moved_two = false;
    }
  }
  checks[0] = teams[0][4].isCheck(teams[0][4].pos);
  checks[1] = teams[1][4].isCheck(teams[1][4].pos);
  kings_pos[0] = teams[0][4].pos.copy();
  kings_pos[1] = teams[1][4].pos.copy();
  mate = isCheckmate(player);
}
