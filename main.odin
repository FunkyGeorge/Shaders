package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"
import gl "vendor:OpenGL"
import "vendor:glfw"

framebuffer_size_callback :: proc "c" (window: glfw.WindowHandle, width: i32, height: i32) {
	gl.Viewport(0, 0, width, height)
}

processInput :: proc "c" (window: glfw.WindowHandle) {
	if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS {
		glfw.SetWindowShouldClose(window, true)
	}
}

shader_set_bool :: proc(id: u32, name: cstring, value: bool) {
	gl.Uniform1i(gl.GetUniformLocation(id, name), i32(value))
}

shader_set_int :: proc(id: u32, name: cstring, value: i32) {
	gl.Uniform1i(gl.GetUniformLocation(id, name), value)
}

shader_set_float :: proc(id: u32, name: cstring, value: f32) {
	gl.Uniform1f(gl.GetUniformLocation(id, name), value)
}

shader_set_vec2_float :: proc(id: u32, name: cstring, x: f32, y: f32) {
	gl.Uniform2f(gl.GetUniformLocation(id, name), x, y)
}

SCR_WIDTH :: 800
SCR_HEIGHT :: 600

main :: proc() {
	run_options := [4]string{"functions", "colors", "shapes", "painting"}
	run_mode := ""

	if len(os.args) > 1 {
		run_mode = os.args[1]
	}

	switch run_mode {
	case "functions":
		RenderShaderProgram("./res/vertex.vert", "./res/fragment.frag")
	case "colors":
		RenderShaderProgram("./res/vertex.vert", "./res/colors/fragment.frag")
	case "shapes":
		RenderShaderProgram("./res/vertex.vert", "./res/shapes/fragment.frag")
	case "painting":
		RenderShaderProgram("./res/vertex.vert", "./res/painting/fragment.frag")
	case:
		fmt.println("Invalid flag, try 'options' or 'o' flag to see valid shaders to run")
		fallthrough
	case "options", "o":
		// Print options
		fmt.println("Options:")
		for o in run_options {
			fmt.println(strings.concatenate({"\t", o}))
		}
		fmt.println("\rTry: odin run . -- <option>")
	}
}

RenderShaderProgram :: proc(vert_file: string, frag_file: string) {
	glfw.Init()
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	start_time := time.now()

	window := glfw.CreateWindow(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL", nil, nil)
	if window == nil {
		fmt.println("Failed to create GLFW window")
		glfw.Terminate()
		os.exit(-1)
	}
	glfw.MakeContextCurrent(window)

	gl.load_up_to(3, 3, glfw.gl_set_proc_address)

	gl.Viewport(0, 0, SCR_WIDTH, SCR_HEIGHT)

	glfw.SetFramebufferSizeCallback(window, framebuffer_size_callback)

	vertices := [?]f32{-1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0}

	// The shader loading they create can be replaced with just this
	shaderProgram, loaded_ok := gl.load_shaders_file(vert_file, frag_file)
	if !loaded_ok {
		os.exit(-1)
	}

	VBO, VAO: u32
	gl.GenVertexArrays(1, &VAO)
	gl.GenBuffers(1, &VBO)

	gl.BindVertexArray(VAO)

	gl.BindBuffer(gl.ARRAY_BUFFER, VBO)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), raw_data(&vertices), gl.STATIC_DRAW)

	gl.VertexAttribPointer(0, 2, gl.FLOAT, gl.FALSE, 2 * size_of(f32), 0)
	gl.EnableVertexAttribArray(0)

	gl.VertexAttribPointer(1, 2, gl.FLOAT, gl.FALSE, 2 * size_of(f32), size_of(f32))
	gl.EnableVertexAttribArray(1)

	for !glfw.WindowShouldClose(window) {
		processInput(window)

		gl.ClearColor(0.2, 0.3, 0.3, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		gl.UseProgram(shaderProgram)
		elapsed := f32(time.duration_seconds(time.since(start_time)))
		shader_set_float(shaderProgram, "u_time", f32(elapsed))
		fb_w, fb_h := glfw.GetFramebufferSize(window)
		shader_set_vec2_float(shaderProgram, "u_resolution", f32(fb_w), f32(fb_h))
		gl.BindVertexArray(VAO)
		gl.DrawArrays(gl.TRIANGLES, 0, 6)

		glfw.SwapBuffers(window)
		glfw.PollEvents()
	}

	gl.DeleteVertexArrays(1, &VAO)
	gl.DeleteBuffers(1, &VBO)
	gl.DeleteProgram(shaderProgram)

	glfw.Terminate()
}

