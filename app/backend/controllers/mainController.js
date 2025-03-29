function getHello (req, res) {
    try {
      const { name } = req.body;

      if (!name) {
        return res.status(400).json({ message: "Name is required" });
    }

      res.json({ message: `Hello, ${name}!` });
    } catch (error) {
      res.status(500).send({ message: 'Failed to create user', error: error.message });
    }
  }
  
  module.exports = {
      getHello
    };