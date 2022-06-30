import path from "path";
import { fileURLToPath } from "url";
import webpack from "webpack";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const mode = "production";
export const devtool = "source-map";
export const entry = {
    application: "./app/javascript/application.js",
    furniture_video_bridge: "./app/furniture/video_bridge/index.js"
};
export const output = {
    filename: "[name].js",
    sourceMapFilename: "[name].js.map",
    path: path.resolve(__dirname, "app/assets/builds"),
};
export const plugins = [
    new webpack.optimize.LimitChunkCountPlugin({
        maxChunks: 1
    })
];
export default {
    mode,
    devtool,
    entry,
    output,
    plugins
};
