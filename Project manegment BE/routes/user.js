const express = require('express');

const userController = require('../controllers/user');

const router = express.Router();

router.post('/login',userController.login);

router.post('/signup',userController.signup);

router.post('/board/create-board',userController.createBoard);

router.post('/board/my-boards',userController.getMyBoards);

router.get('/all',userController.getAllUsers);

router.get('/my-cards/:userId',userController.getMyCards);

module.exports = router;