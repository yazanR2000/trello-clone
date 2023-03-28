const express = require('express');

const listCardsController = require('../controllers/list-cards');
const router = express.Router();

router.get('/cards/:listId',listCardsController.getListCards);

router.post('/add-member',listCardsController.addCardMembers);

router.delete('/delete-member',listCardsController.deleteCardMember);

router.delete('/delete-card/:listId/:cardId',listCardsController.deleteCard);

router.put('/edit',listCardsController.editCard);

router.get('/card-comments/:cardId',listCardsController.getCardComments);

router.post('/move',listCardsController.moveCard); 

router.post('/add-card',listCardsController.addNewCard);

router.put('/move-all-cards',listCardsController.moveAllCardsToList);

router.get('/card-members/:cardId',listCardsController.getCardMembers);

module.exports = router;