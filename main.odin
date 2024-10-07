package main

import "core:fmt"
import math "core:math"
import rl "vendor:raylib"

main :: proc() {
	windowWidth :: 1280
	windowHeight :: 720

	rl.SetConfigFlags({.MSAA_4X_HINT, .VSYNC_HINT})
	rl.InitWindow(windowWidth, windowHeight, "Odin Raylib Template")

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()

		rl.ClearBackground(rl.SKYBLUE)
		rl.DrawText("Odin + Raylib Template", 20, 20, 20, rl.WHITE)

		line_a_start := rl.Vector2{600, 100}
		line_a_end := rl.Vector2{600, 400}

		line_b_start := rl.GetMousePosition()
		line_b_end := line_b_start + {300, 0}

		collision_point: rl.Vector2

		if rl.CheckCollisionLines(
			line_a_start,
			line_a_end,
			line_b_start,
			line_b_end,
			&collision_point,
		) {
			rl.DrawCircleV(collision_point, 10.0, rl.RED)
		}

		rl.DrawLineV(line_a_start, line_a_end, rl.WHITE)
		rl.DrawLineV(line_b_start, line_b_end, rl.WHITE)

		rl.EndDrawing()
	}
}
