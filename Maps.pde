//Holding maps in a class provides easy organization even though it isn't strictly necessary.
class Maps{
  //The entries in this map have been moved around so that the map can generate faster and disappear faster in the current setup.
  //This is the map with the most walls and therefore all subsequent maps needed 16 walls to facilitate the obstacle movement system.
  public int[][] map1 = {  
    // These are the four walls to stop players leaving the map
    {cx, -5, w, 5}, //0
    {cx, h+5, w, 5}, //1
    {-5, cy, 5, h}, //2
    {w+5, cy, 5, h}, //3
    
    // Central columns
    {cx, cy-150, 100, 200}, //4
    {cx, cy-250, 200, 100}, //5
    {cx, cy+150, 100, 200}, //6
    {cx, cy+250, 200, 100}, //7
    
    // Bottom parts
    {cx/2, cy+350, 100, 300}, //8
    /*{cx/2 + 50, cy+250, 100, 100},*/
    {(cx*3)/2, cy+350, 100, 300}, //9
    //10 and eleven switch
    {cx/2 + 50, cy+250, 100, 100}, //10 //Moved to hopefuly change indexes and speed up map generation
    
    {(cx*3)/2 - 50, cy+250, 100, 100}, //11
    
    
    
    // Top parts
    {cx/2, cy-350, 100, 300}, //12
    /*{cx/2 + 50, cy-250, 100, 100},*/
    {(cx*3)/2, cy-350, 100, 300}, //13
    {cx/2 + 50, cy-250, 100, 100}, //14 //Also trying to shift indexes for faster map generation switching 14 and 15
    {(cx*3)/2 - 50, cy-250, 100, 100}, //15
    
    
  };
  
  public int[][] map2 = {
    // These are the four walls to stop players leaving the map
    {cx, -5, w, 5}, 
    {cx, h+5, w, 5}, 
    {-5, cy, 5, h}, 
    {w+5, cy, 5, h},
  
    // Central columns
    {cx, cy-50, 100, 100},
    //{cx, cy-150, 250, 150},
    {cx, cy+50, 100, 100},
    //{cx, cy+50, 250, 150},
    //Move extra walls out of the gameplay area and set their size to 0 which effectivly removes them from existance.
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0}
  };
  
  public int[][] map3 = {
    // These are the four walls to stop players leaving the map
    {cx, -5, w, 5}, 
    {cx, h+5, w, 5}, 
    {-5, cy, 5, h}, 
    {w+5, cy, 5, h},
  
    // Central columns
    //{cx, cy-50, 100, 100},
    {cx, cy-220, 250, 150},
    //{cx, cy+50, 100, 100},
    {cx, cy+220, 250, 150},
    //Gets rid of unwanted walls.
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0}
  };
  
  public int[][] map4 = {
    // These are the four walls to stop players leaving the map
    {cx, -5, w, 5}, 
    {cx, h+5, w, 5},
    {-5, cy, 5, h}, 
    {w+5, cy, 5, h},
    
    //Two walls infront of players
    {cx-400, cy, 100, 400},
    {cx+400, cy, 100, 400},
    
    {cx-200, cy, 400, 100},
    {cx+200, cy, 400, 100},
    //Stops the game from crashing by ordering extra walls to move away.
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0},
    {0, 0, 0, 0},
    {w, h, 0, 0}
  };
  //Easy storage of all the maps. Choosing a map in this map array is equivilant to the "mode" in obsticles and colliders.
  public int[][][] maps = {map1, map2, map3, map4};

}