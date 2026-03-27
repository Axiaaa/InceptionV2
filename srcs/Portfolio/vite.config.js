import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    tailwindcss(),
  ],
  server: { 
    host: "0.0.0.0",
    allowedHosts: ["portfolio.lcamerly.42.fr"],
    port: 5173,
    watch: {
      ignored: ['./*']
    },
    hmr: false
  },
})