import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import * as Path from "path";

// https://vitejs.dev/config/
export default defineConfig({
    root: __dirname,
    publicDir: Path.join(__dirname, "./public"),
    plugins: [react()],
    server: {
        port: 3000,
        hmr: true
    }
})