--Great Kanohi Akaku
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN,4)
Debug.SetPlayerInfo(0,8000,0,1)
Debug.SetPlayerInfo(1,8000,0,1)
Debug.AddCard(10100011,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100011,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(55144522,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(70368879,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(25067275,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(20848593,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100005,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(93506862,0,0,LOCATION_GRAVE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10045474,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
for i=1,5 do
  Debug.AddCard(70368879,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
end
Debug.AddCard(10100005,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(10045474,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(55144522,1,1,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(70368879,1,1,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10045474,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(12694768,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(93506862,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
for i=1,5 do
  Debug.AddCard(5318639,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
end
Debug.AddCard(12694768,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(93506862,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(98494543,1,1,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.ReloadFieldEnd()
