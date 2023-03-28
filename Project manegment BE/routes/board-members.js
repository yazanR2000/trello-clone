const express = require('express');

const boardMembersController = require('../controllers/board-members');

const router = express.Router();

router.post('/add',boardMembersController.addBoardMembers);

router.delete('/delete',boardMembersController.deleteBoardMember);

router.post('/edit',boardMembersController.editBoardMember);

module.exports = router;