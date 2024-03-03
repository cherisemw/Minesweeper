import de.bezier.guido.*;
private int NUM_ROWS = 15;
private int NUM_COLS = 15;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );

    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for (int r = 0; r < NUM_ROWS; r++){
        for (int c = 0; c < NUM_COLS; c++){
            buttons[r][c] = new MSButton(r,c);
        }
    }
    
    setMines();
}
public void setMines()
{
    int row[] = new int[20];
    int col[] = new int[20];
    for (int i = 0; i < row.length; i++){
      row[i] = (int)(Math.random()*(NUM_ROWS-1));
      col[i] = (int)(Math.random()*(NUM_COLS-1));
      if (mines.contains(buttons[row[i]][col[i]]) == false){
        mines.add(buttons[row[i]][col[i]]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  boolean allClicked = true;
  boolean allFlagged = true;
  boolean won = false;
  for (int r = 0; r < NUM_ROWS; r++){
    for (int c = 0; c < NUM_COLS; c++){
      if (buttons[r][c].clicked == false){
        allClicked = false;
        break;
      }
    }
  }
  for (int i = 0; i < mines.size(); i++){
    if (mines.get(i).isFlagged() == false){
      allFlagged = false;
    }
  }
  if (allClicked == true && allFlagged == true){
    won = true;
  }  
  return won;
}

public void displayLosingMessage()
{
  String message = "You lost :(";
  for (int i = 0; i < message.length(); i++){
    buttons[0][i].setLabel(message.substring(i,i+1));
  }
  for (int i = 0; i < mines.size(); i++){
    mines.get(i).clicked = true;
  }
}
public void displayWinningMessage()
{
  String message = "You won!!!";
  for (int i = 0; i < message.length(); i++){
    buttons[0][i].setLabel(message.substring(i,i+1));
  }
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >=0 && c < NUM_COLS){
      return true;
    }
    else {
      return false;
    }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    if (isValid(row-1, col-1) == true && mines.contains(buttons[row-1][col-1]) == true){
      numMines += 1;
    }
    if (isValid(row-1, col) == true && mines.contains(buttons[row-1][col]) == true){
      numMines += 1;
    }
    if (isValid(row-1, col+1) == true && mines.contains(buttons[row-1][col+1]) == true){
      numMines += 1;
    }
    if (isValid(row, col-1) == true && mines.contains(buttons[row][col-1]) == true){
      numMines += 1;
    }
    if (isValid(row, col+1) == true && mines.contains(buttons[row][col+1]) == true){
      numMines += 1;
    }
    if (isValid(row+1, col-1) == true && mines.contains(buttons[row+1][col-1]) == true){
      numMines += 1;
    }
    if (isValid(row+1, col) == true && mines.contains(buttons[row+1][col]) == true){
      numMines += 1;
    }
    if (isValid(row+1, col+1) == true && mines.contains(buttons[row+1][col+1]) == true){
      numMines += 1;
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT){
          flagged = !flagged;
          if (flagged == false){
            clicked = false;
          }
        }
        else if (mines.contains(this)){
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0){
          myLabel = Integer.toString(countMines(myRow, myCol));
        }
        else {
          if (isValid(myRow-1, myCol-1) == true && buttons[myRow-1][myCol-1].clicked == false){
            buttons[myRow-1][myCol-1].mousePressed();
          }
          if (isValid(myRow-1, myCol) == true && buttons[myRow-1][myCol].clicked == false){
            buttons[myRow-1][myCol].mousePressed();
          }
          if (isValid(myRow-1, myCol+1) == true && buttons[myRow-1][myCol+1].clicked == false){
            buttons[myRow-1][myCol+1].mousePressed();
          }
          if (isValid(myRow, myCol-1) == true && buttons[myRow][myCol-1].clicked == false){
            buttons[myRow][myCol-1].mousePressed();
          }
          if (isValid(myRow-1, myCol+1) == true && buttons[myRow-1][myCol+1].clicked == false){
            buttons[myRow-1][myCol+1].mousePressed();
          }
          if (isValid(myRow+1, myCol-1) == true && buttons[myRow+1][myCol-1].clicked == false){
            buttons[myRow+1][myCol-1].mousePressed();
          }
          if (isValid(myRow+1, myCol) == true && buttons[myRow+1][myCol].clicked == false){
            buttons[myRow+1][myCol].mousePressed();
          }
          if (isValid(myRow+1, myCol+1) == true && buttons[myRow+1][myCol+1].clicked == false){
            buttons[myRow+1][myCol+1].mousePressed();
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
