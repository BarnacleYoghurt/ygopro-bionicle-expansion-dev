--Quest for the Masks
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN,4)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)
Debug.AddCard(10100016,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100001,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100002,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100003,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100010,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100041,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100056,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100010,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(10100041,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(10100056,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.ReloadFieldEnd()
