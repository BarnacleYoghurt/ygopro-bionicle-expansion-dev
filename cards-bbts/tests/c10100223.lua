--Bohrok Invasion
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)
Debug.AddCard(10100223,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100204,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100204,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK)
Debug.AddCard(10100204,0,0,LOCATION_MZONE,4,POS_FACEDOWN_DEFENSE)
Debug.AddCard(10100223,0,0,LOCATION_SZONE,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(10100201,0,0,LOCATION_GRAVE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100215,0,0,LOCATION_GRAVE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100201,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(10100215,0,0,LOCATION_DECK,2,POS_FACEDOWN_ATTACK)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,3,POS_FACEUP_ATTACK)
Debug.ReloadFieldEnd()
