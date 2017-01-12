const path = require('path')
const CopyWebpackPlugin = require('copy-webpack-plugin')

const config = {
    entry: {
        'popup.js': './js/popup.js',
        'background.js': './js/background.js',
    },
    output: {
        path: path.resolve(__dirname, 'ext'),
        filename: '[name]',
    },
    resolve: {
        extensions: ['.js', '.elm'],
    },
    module: {
        rules: [
            {
                test: /\.elm$/,
                use: [{
                    loader: 'elm-webpack-loader',
                    options: {
                        verbose: true,
                        warn: true,
                        cwd: path.resolve(__dirname),
                    },
                }],
                include: path.resolve(__dirname, 'src'),
            },
        ],
    },
    plugins: [
        new CopyWebpackPlugin([{ from: 'static' }]),
    ],
}

module.exports = config
