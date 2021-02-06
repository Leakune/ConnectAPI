// load up our shiny new route for marketsCoins
const marketRoutes = require('./marketsCoins');

const appRouter = (app, fs) => {
  // we've added in a default route here that handles empty routes
  // at the base API url
  app.get('/', (req, res) => {
    res.send('welcome to the development api-server');
  });

  // run our market route module here to complete the wire up
  marketRoutes(app, fs);
};

// this line is unchanged
module.exports = appRouter;