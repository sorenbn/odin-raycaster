package main

import "core:fmt"
import math "core:math"
import rl "vendor:raylib"

ray :: struct {
	start:  rl.Vector2,
	dir:    rl.Vector2,
	length: f32,
}

main :: proc() {
	WINDOW_WIDTH :: 1280
	WINDOW_HEIGHT :: 720
	RAY_LENGTH :: 300

	rl.SetConfigFlags({.MSAA_4X_HINT, .VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Odin Raylib Template")

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.Color{25, 25, 25, 255})

		wall_start := rl.Vector2{600, 100}
		wall_end := rl.Vector2{600, 400}

		light_start := rl.GetMousePosition()

		for i := 0; i < 360; i += 5 {
			ray: ray = {
				start  = light_start,
				dir    = angle_to_dir_vector(f32(i)),
				length = RAY_LENGTH,
			}

			rl.DrawLineV(ray.start, ray.start + ray.dir * ray.length, rl.WHITE)
		}

		// collision_point: rl.Vector2

		// if rl.CheckCollisionLines(
		// 	wall_start,
		// 	wall_end,
		// 	light_start,
		// 	line_b_end,
		// 	&collision_point,
		// ) {
		// 	rl.DrawCircleV(collision_point, 10.0, rl.RED)
		// }

		rl.EndDrawing()
	}

	angle_to_dir_vector :: proc(angle_in_deg: f32) -> rl.Vector2 {
		angle_in_rad := math.to_radians_f32(angle_in_deg)
		return rl.Vector2{math.cos(angle_in_rad), math.sin(angle_in_rad)}
	}
}
