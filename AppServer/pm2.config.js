module.exports = {
  apps: [
    {
      name: 'xc',
      script: 'bin/www',
      node_args: '-r dotenv/config',
      instances: 'max',
      exec_mode: 'cluster',
    },
  ],
};
