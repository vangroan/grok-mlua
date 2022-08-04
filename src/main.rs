use cgmath::Vector2;
use mlua::{prelude::*, LuaOptions, StdLib};
use std::time::Instant;

#[derive(Copy, Clone)]
struct Vec2 {
    x: f64,
    y: f64,
}

impl LuaUserData for Vec2 {
    fn add_fields<'lua, F: LuaUserDataFields<'lua, Self>>(_fields: &mut F) {}

    fn add_methods<'lua, M: LuaUserDataMethods<'lua, Self>>(methods: &mut M) {
        methods.add_meta_function(mlua::MetaMethod::Add, |_, (a, b): (Vec2, Vec2)| {
            Ok(Vec2 {
                x: a.x + b.x,
                y: a.y + b.y,
            })
        });
    }
}

fn main() -> LuaResult<()> {
    let libs = StdLib::ALL;
    let options = LuaOptions::default();
    let lua = unsafe { Lua::unsafe_new_with(libs, options) };

    let map_table = lua.create_table()?;
    map_table.set(1, "one")?;
    map_table.set("two", 2)?;

    lua.globals().set("map_table", map_table)?;

    lua.load("for k,v in pairs(map_table) do print(k,v) end")
        .exec()?;

    lua.load(include_str!("../scripts/game.lua"))
        .set_name("game")?
        .set_mode(mlua::ChunkMode::Text)
        .exec()?;
    let game: mlua::Table = lua.globals().get("Game")?;
    let update: mlua::Function = game.get("update")?;
    update.call::<_, ()>(())?;
    update.call::<_, ()>(())?;
    update.call::<_, ()>(())?;

    println!("Rust vector math");

    // elapsed time: 0.004
    let mut t: Vec<Vector2<f64>> = vec![];
    let a = Vector2::new(1., 2.);
    let s = Instant::now();
    for i in 0..1_000_000 {
        t.push(Vector2::new(i as f64 * 2., i as f64 * 3.) + a);
    }
    println!("elapsed time: {:.3}", (Instant::now() - s).as_secs_f64());

    let vec2_constructor = lua.create_function(|_, (x, y): (f64, f64)| Ok(Vec2 { x, y }))?;
    lua.globals().set("rust_vec2", vec2_constructor)?;

    println!("Lua userdata vector math");
    // elapsed time: 2.403
    lua.load(
        r#"
    do
      local t = {}
      local a = rust_vec2(1, 2)
      local s = os.clock()
      for i = 1, 1000000 do t[i] = rust_vec2(i * 2, i * 3) + a end
      print(string.format("elapsed time: %.3f\n", os.clock() - s))
    end
    "#,
    )
    .exec()?;

    Ok(())
}
