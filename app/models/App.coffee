#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    #New Deck and deal both hands
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    #Event Listeners
    @get('playerHand').on 'stand', => 
      playerScore = @get('playerHand').scores()
      if playerScore[1] is 21 then @endGame()
      @dealerTurn()
    @get('playerHand').on 'hit', => 
      playerScore = @get('playerHand').scores()
      if playerScore[0] >= 21 or playerScore[1] is 21 then @endGame()

  dealerTurn: ->
    @get('dealerHand').at(0).flip()
    @checkDealerScore()

  checkDealerScore: ->
    dealerScore = @get('dealerHand').scores()
    console.log(dealerScore)

    if dealerScore[1] <= 21 then dealerScore = dealerScore[1] else dealerScore = dealerScore[0]

    if dealerScore < 17 then @get('dealerHand').hit() and @checkDealerScore()
    if dealerScore >= 17 then @endGame()

  endGame: ->
    console.log "Game Ended!"

    playerScore = @get('playerHand').scores()
    dealerScore = @get('dealerHand').scores() 

    #Set scores to the best score
    if playerScore[1] <= 21 then playerScore = playerScore[1] else playerScore = playerScore[0]
    if dealerScore[1] <= 21 then dealerScore = dealerScore[1] else dealerScore = dealerScore[0]

    if playerScore > 21 then console.log "Player busted! Dealer Wins!"
    if dealerScore > 21 then console.log "Dealer Bust!", "Player Wins!"
    if 21 >= playerScore > dealerScore then console.log "Player Wins!"
    if 21 >= dealerScore > playerScore then console.log "Dealer Wins!"
    if playerScore is dealerScore then console.log "Push!"

    setTimeout (=> 
      @initialize()
      @trigger 'endGame'
      ), 2000
    