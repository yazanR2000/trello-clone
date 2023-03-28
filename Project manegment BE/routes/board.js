const express = require('express');

const boardController = require('../controllers/board');

const router = express.Router();

router.get('/board-members/:boardId',boardController.getBoardMembers);

router.get('/board-lists/:boardId',boardController.getBoardLists);

router.get('/board-cards/:boardId',boardController.getBoardCards);

router.delete('/delete-list',boardController.deleteList);

router.post('/create-new-list',boardController.createNewList);

module.exports = router;