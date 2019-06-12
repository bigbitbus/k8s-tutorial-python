/* global describe it cy expect */

describe('Poll Test', function() {
    it('Tests the poll system flow', function() {
        cy.visit('/polls/');

        cy.get('ul>li>a:first').click();
        cy.location().should(function(loc) { expect(loc.pathname).to.eq('/polls/1/'); });

        cy.get('form>label[for=choice3]').click();
        cy.get('form>input[type=submit]').click();
        cy.location().should(function(loc) { expect(loc.pathname).to.eq('/polls/1/results/'); });

        cy.get('ul > :nth-child(3)').contains('Yes, I love beer! -- 1 vote')
    });
});