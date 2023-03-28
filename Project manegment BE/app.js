const express = require("express");
const bodyParser = require("body-parser");


const User = require('./models/user');
const Board = require('./models/board');
const BoardLists = require('./models/board-lists');
const BoardMembers = require('./models/board-members');
const ListCards = require('./models/list-cards');
const CardAttechements = require('./models/card-attachements');
const CardComments = require('./models/card-comments');
const CardMembers = require('./models/card-members');


const sequelize = require("./util/database");

const app = express();
app.use(bodyParser.json());

const userRoutes = require('./routes/user');
const boardRoutes = require('./routes/board');
const boardMembersRoutes = require('./routes/board-members');
const listCardsRoutes = require('./routes/list-cards');





app.use('/user', userRoutes);
app.use('/board',boardRoutes);
app.use('/board-members',boardMembersRoutes);
app.use('/board-lists',listCardsRoutes);



User.hasMany(Board);
Board.belongsTo(User);

Board.hasMany(BoardLists,{
    onDelete: 'CASCADE',
});
BoardLists.belongsTo(Board);

Board.hasMany(BoardMembers,{
    onDelete: 'CASCADE',
});
BoardMembers.belongsTo(Board);
User.hasOne(BoardMembers,{
    onDelete: 'CASCADE',
});
BoardMembers.belongsTo(User);

BoardLists.hasMany(ListCards,{
    onDelete: 'CASCADE',
});
ListCards.belongsTo(BoardLists);

Board.hasMany(ListCards,{
    onDelete: 'CASCADE',
});
ListCards.belongsTo(Board);

ListCards.hasMany(CardMembers,{
    onDelete: 'CASCADE',
});
CardMembers.belongsTo(ListCards);
User.hasMany(CardMembers,{
    onDelete: 'CASCADE',
});
CardMembers.belongsTo(User);

ListCards.hasMany(CardAttechements,{
    onDelete: 'CASCADE',
});
CardAttechements.belongsTo(ListCards);

ListCards.hasMany(CardComments,{
    onDelete: 'CASCADE',
});
CardComments.belongsTo(ListCards);
User.hasMany(CardComments,{
    onDelete: 'CASCADE',
});
CardComments.belongsTo(User);


sequelize
  .sync()
  .then((result) => {
    // console.log("yazan:",result);
    const server = app.listen(8080);
    const io = require('./socket').init(server);
    io.on('connection', socket => {
      console.log('Client connected');
    });
  })
  .catch((err) => {
    console.log(err);
  });
