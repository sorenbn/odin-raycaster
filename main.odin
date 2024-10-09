package main

import "core:fmt"
import math "core:math"
import rl "vendor:raylib"
import rlgl "vendor:raylib/rlgl"

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

walls: [10]wall
rays: [dynamic]ray
verticies: [dynamic]rl.Vector2
triangles: [dynamic]i32

main :: proc() {

	rl.SetConfigFlags({.MSAA_4X_HINT, .VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Odin Raylib Template")

	initialize_scene()

	for (!rl.WindowShouldClose()) {
		rl.BeginDrawing()
		rl.ClearBackground(rl.Color{25, 25, 25, 255})

		clear(&rays)
		clear(&verticies)
		clear(&triangles)

		light_start := rl.GetMousePosition()
		append(&verticies, light_start)

		for i := 0; i < 360; i += 1 {
			ray: ray = {
				start  = light_start,
				dir    = angle_to_direction(f32(i)),
				length = RAY_LENGTH,
			}

			append(&rays, ray)
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
				append(&verticies, closest_collision_point)
				// rl.DrawLineV(ray.start, closest_collision_point, rl.WHITE)
			} else {
				append(&verticies, ray.start + ray.dir * ray.length)
				// rl.DrawLineV(ray.start, ray.start + ray.dir * ray.length, rl.WHITE)
			}
		}

		for w in walls {
			rl.DrawLineEx(w.start, w.end, WALL_THICKNESS, rl.BLUE)
		}

		for i := 0; i < len(verticies) - 2; i += 1 {
			a := i32(0)
			b := i32(i + 2)
			c := i32(i + 1)
			append(&triangles, a, b, c)
		}

		append(&triangles, i32(0), i32(1), i32(len(verticies) - 1))

		for i := 0; i < len(triangles); i += 3 {
			a := triangles[i]
			b := triangles[i + 1]
			c := triangles[i + 2]
			// rl.DrawTriangle(verticies[a], verticies[b], verticies[c], rl.Fade(rl.YELLOW, 0.5))
			draw_rlgl_triangle(verticies[a], verticies[b], verticies[c], rl.YELLOW)
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

	draw_rlgl_triangle :: proc(center, edge1, edge2: rl.Vector2, color: rl.Color) {
		rlgl.Begin(rlgl.TRIANGLES)

		rlgl.Color4ub(color.r, color.g, color.b, 255)
		rlgl.Vertex2f(center.x, center.y)

		length_edge1 := rl.Vector2Distance(center, edge1)
		normalized_length_edge1 := length_edge1 / RAY_LENGTH

		length_edge2 := rl.Vector2Distance(center, edge2)
		normalized_length_edge2 := length_edge2 / RAY_LENGTH

		rlgl.Color4ub(color.r, color.g, color.b, u8(255 * normalized_length_edge1 * -1))
		rlgl.Vertex2f(edge1.x, edge1.y)

		rlgl.Color4ub(color.r, color.g, color.b, u8(255 * normalized_length_edge1 * -1))
		rlgl.Vertex2f(edge2.x, edge2.y)

		rlgl.End()
	}
}
