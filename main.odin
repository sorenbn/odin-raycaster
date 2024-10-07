package main

import "core:fmt"
import math "core:math"
import rl "vendor:raylib"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720
RAY_LENGTH :: 500
WALL_THICKNESS :: 5

ray :: struct {
	start:  rl.Vector2,
	dir:    rl.Vector2,
	length: f32,
}

wall :: struct {
	start: rl.Vector2,
	end:   rl.Vector2,
}

rays: [360]ray
walls: [10]wall

main :: proc() {

	rl.SetConfigFlags({.MSAA_4X_HINT, .VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Odin Raylib Template")

	initialize_scene()

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.Color{25, 25, 25, 255})

		light_start := rl.GetMousePosition()

		for i := 0; i < 360; i += 1 {
			ray: ray = {
				start  = light_start,
				dir    = angle_to_direction(f32(i)),
				length = RAY_LENGTH,
			}

			rays[i] = ray
		}

		for ray in rays {
			closest_collision_point: rl.Vector2
			found_collision: bool = false
			min_distance: f32 = ray.length

			for w in walls {
				collision_point: rl.Vector2

				if rl.CheckCollisionLines(
					ray.start,
					ray.start + ray.dir * ray.length,
					w.start,
					w.end,
					&collision_point,
				) {
					distance := rl.Vector2Distance(ray.start, collision_point)

					if distance < min_distance {
						closest_collision_point = collision_point
						min_distance = distance
						found_collision = true
					}
				}
			}

			if found_collision {
				rl.DrawLineV(ray.start, closest_collision_point, rl.WHITE)
				// rl.DrawCircleV(closest_collision_point, 5.0, rl.RED)
			} else {
				rl.DrawLineV(ray.start, ray.start + ray.dir * ray.length, rl.WHITE)
			}
		}

		for w in walls {
			rl.DrawLineEx(w.start, w.end, WALL_THICKNESS, rl.BLUE)
		}

		fps := fmt.ctprintf("FPS: %v", i32(1.0 / rl.GetFrameTime()))
		rl.DrawText(fps, 20, 20, 20, rl.WHITE)

		rl.EndDrawing()
	}

	initialize_scene :: proc() {
		walls[0] = {
			start = {0, 0},
			end   = {WINDOW_WIDTH, 0},
		}
		walls[1] = {
			start = {WINDOW_WIDTH, 0},
			end   = {WINDOW_WIDTH, WINDOW_HEIGHT},
		}
		walls[2] = {
			start = {WINDOW_WIDTH, WINDOW_HEIGHT},
			end   = {0, WINDOW_HEIGHT},
		}
		walls[3] = {
			start = {0, WINDOW_HEIGHT},
			end   = {0, 0},
		}
		walls[4] = {
			start = {400, 100},
			end   = {600, 100},
		}
		walls[5] = {
			start = {600, 100},
			end   = {600, 300},
		}
		walls[6] = {
			start = {600, 300},
			end   = {400, 300},
		}
		walls[7] = {
			start = {400, 300},
			end   = {400, 100},
		}
		walls[8] = {
			start = {800, 500},
			end   = {800, 600},
		}
		walls[9] = {
			start = {800, 500},
			end   = {1000, 500},
		}
	}

	angle_to_direction :: proc(angle_in_deg: f32) -> rl.Vector2 {
		angle_in_rad := math.to_radians_f32(angle_in_deg)
		return rl.Vector2{math.cos(angle_in_rad), math.sin(angle_in_rad)}
	}
}
