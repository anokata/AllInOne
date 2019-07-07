return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 20,
  height = 20,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 7,
  nextobjectid = 10,
  properties = {
    ["walktiles"] = "1,3"
  },
  tilesets = {
    {
      name = "tileset128",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 32,
      image = "tileset/tileset128.png",
      imagewidth = 1024,
      imageheight = 1024,
      transparentcolor = "#000000",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 1024,
      tiles = {}
    }
  },
  layers = {
    {
      type = "objectgroup",
      id = 3,
      name = "Object Layer 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 3,
          name = "wall",
          type = "",
          shape = "rectangle",
          x = 0,
          y = -1,
          width = 62,
          height = 413,
          rotation = 0,
          visible = true,
          properties = {
            ["bodyType"] = "static"
          }
        },
        {
          id = 7,
          name = "wall",
          type = "",
          shape = "rectangle",
          x = 42,
          y = -2.5,
          width = 262,
          height = 68,
          rotation = 0,
          visible = true,
          properties = {
            ["bodyType"] = "static"
          }
        },
        {
          id = 8,
          name = "wall",
          type = "",
          shape = "rectangle",
          x = 57,
          y = 345,
          width = 262,
          height = 68,
          rotation = 0,
          visible = true,
          properties = {
            ["bodyType"] = "static"
          }
        },
        {
          id = 9,
          name = "wall",
          type = "",
          shape = "rectangle",
          x = 161,
          y = 163.5,
          width = 30,
          height = 29,
          rotation = 0,
          visible = true,
          properties = {
            ["bodyType"] = "static"
          }
        }
      }
    },
    {
      type = "tilelayer",
      id = 6,
      name = "Ground",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        4, 4, 1, 1, 1, 1, 1, 1, 4, 8, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4,
        4, 4, 1, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 3, 3, 4, 4,
        4, 4, 1, 3, 3, 3, 3, 3, 3, 8, 8, 4, 4, 4, 4, 4, 4, 3, 4, 4,
        4, 4, 1, 3, 3, 5, 3, 3, 1, 8, 8, 4, 3, 3, 3, 3, 3, 3, 4, 4,
        4, 4, 1, 3, 3, 3, 3, 3, 1, 8, 8, 4, 3, 4, 4, 4, 4, 3, 4, 4,
        4, 4, 1, 3, 3, 3, 3, 3, 1, 8, 8, 4, 3, 4, 4, 4, 4, 3, 4, 4,
        4, 4, 1, 3, 3, 3, 3, 3, 1, 8, 8, 4, 3, 3, 3, 3, 3, 3, 4, 4,
        4, 4, 1, 3, 3, 3, 3, 3, 3, 8, 8, 4, 3, 4, 4, 4, 4, 3, 4, 4,
        4, 4, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 4, 4, 4, 4, 3, 4, 4,
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4,
        4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 4, 4, 4, 3, 4, 4,
        4, 4, 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 3, 4, 4, 4, 4, 3, 4, 4,
        3, 3, 4, 4, 4, 3, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, 4, 3, 4, 4,
        4, 3, 3, 3, 3, 3, 4, 3, 3, 4, 4, 4, 4, 3, 4, 4, 4, 3, 4, 4,
        4, 4, 3, 4, 4, 4, 3, 3, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 4, 4,
        4, 4, 3, 4, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        4, 4, 3, 3, 4, 4, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        4, 4, 4, 4, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
      }
    }
  }
}
