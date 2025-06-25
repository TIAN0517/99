import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
    plugins: [vue()],
    resolve: {
        alias: {
            '@assets': path.resolve(__dirname, 'src/renderer/assets'),
            '@styles': path.resolve(__dirname, 'src/renderer/styles'),
            '@components': path.resolve(__dirname, 'src/renderer/components'),
            '@pages': path.resolve(__dirname, 'src/renderer/pages'),
            '@utils': path.resolve(__dirname, 'src/renderer/utils'),
        },
    },
    css: {
        preprocessorOptions: {
            css: {
                additionalData: `@import "@styles/theme.css";`
            }
        }
    },
    server: {
        proxy: {
            '/api': 'http://localhost:8000',
        },
        open: true,
    },
    assetsInclude: ['**/*.svg', '**/*.woff2', '**/*.woff', '**/*.ttf'],
    publicDir: 'public',
})
