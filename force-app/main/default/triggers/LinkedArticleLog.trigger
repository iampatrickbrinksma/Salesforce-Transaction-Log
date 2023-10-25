trigger LinkedArticleLog on LinkedArticle (before insert, before update, before delete, after insert, after update, after delete) {
    new txnLog('LinkedArticleLog').run();
}