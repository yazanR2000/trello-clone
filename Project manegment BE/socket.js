let io;

module.exports = {
  init: (httpServer) => {
    io = require("socket.io")(httpServer);
    return io;
  },
  getIO: () => {
    if (!io) {
      console.log("Socket not connected");
    } else {
        console.log("Connected");
      return io;
    }
  },
};
