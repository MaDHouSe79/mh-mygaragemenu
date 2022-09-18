## QB-MyGarageMenu 
- Get your vehicle from the garage wherever you are at the time.

## How to install.
- Copy the directory `qb-mygaragemenu` to `resources/[qb]/`
- Press in game `F8` and type `refresh` and then type `ensure qb-mygaragemenu` or restart your server.

## QB-MyGarageMenu 
- Get your vehicle from the garage wherever you are at the time.

## How to install.
- Copy the directory `qb-mygaragemenu` to `resources/[qb]/`
- Press in game `F8` and type `refresh` and then type `ensure qb-mygaragemenu` or restart your server.


## Add To in `qb-radialmenu/config.lua` inside the `Config.MenuItems` 
```lua
[3] = { -- change this number 3 if you have more or less in this list.
    {
        id = 'mengaragemenu',
        title = 'My Garage',
        icon = 'car',
        type = 'client',
        event = 'mh-mygaragemenu:client:myVehicles',
        shouldClose = true,            
    }
}
```

## `Config.MenuItems` Example
```lua
Config.MenuItems = {
    [1] = {
        -- menu items
    },
    [2] = {
        -- menu items
    },
    [3] = { -- change this number 3 if you have more or less in this list. place it at the bottom
        {
            id = 'mengaragemenu',
            title = 'My Garage',
            icon = 'car',
            type = 'client',
            event = 'mh-mygaragemenu:client:myVehicles',
            shouldClose = true,            
        }
    }
}
```


## 🐞 Any bugs, let my know.

## 🙈 Youtube & Discord
- [Youtube](https://www.youtube.com/c/MaDHouSe79)
- [Discord](https://discord.gg/cEMSeE9dgS)

## 🐞 Any bugs, let my know.

## 🙈 Youtube & Discord
- [Youtube](https://www.youtube.com/c/MaDHouSe79)
- [Discord](https://discord.gg/cEMSeE9dgS)
