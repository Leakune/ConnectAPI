const marketRoutes = (app, fs) => {
  // variables
  const dataPath = './data/marketsCoins.json';
  let id = 3;

  // helper methods
  const readFile = (callback, returnJson = false, filePath = dataPath, encoding = 'utf8') => {
    fs.readFile(filePath, encoding, (err, data) => {
        if (err) {
            throw err;
        }

        callback(returnJson ? JSON.parse(data) : data);
    });
  };

  // const writeFile = (fileData, callback, filePath = dataPath, encoding = 'utf8') => {

  //     fs.writeFile(filePath, fileData, encoding, (err) => {
  //         if (err) {
  //             throw err;
  //         }

  //         callback();
  //     });
  // };

  // READ (All)
  app.get('/marketsCoins', (req, res) => {
    readFile(data => {
      res.send(data);
    }, true);
  });

  // READ (one)
  app.get('/marketsCoins/:id', (req, res) => {
    readFile(data => {
      const found = data.find(market => market.ID == req.params.id);
      if(!found) {
        return res.status(404).end();
      }
      //res.json(found);
      res.send(found);
      }, true);
  });

  // UPDATE
  app.put('/marketsCoins/:id', (req, res) => {
    readFile(data => {
      const found = data.find(market => market.id == req.params.id);
      if(!found) {
        return res.status(404).end();
      }
      //TODO test data[found]
      const userId = req.params["id"];
      data[userId] = req.body;
      res.status(204).end();
    }, true);
  });
  
  // CREATE
  app.post('/marketsCoins', (req, res) => {
    if(req.body.name === undefined ||
      req.body.intensity === undefined ||
      req.body.price === undefined) {
        return res.status(400).end();
    }
    readFile(data => {
      data.push({
        "ID" : ++id,
        ...req.body
      });
      res.status(201).end();
    }, true);
  });

  // DELETE
  app.delete('/marketsCoins/:id', (req, res) => {
    readFile(data => {
      const deleteId = parseInt(req.params.id);
      const foundIndex = data.findIndex((market) => market.id === deleteId);
      if(foundIndex === -1) {
        return res.status(404).end();
      }
      data.splice(foundIndex, 1);
      res.status(204).end();
    }, true);
  });
};

module.exports = marketRoutes;