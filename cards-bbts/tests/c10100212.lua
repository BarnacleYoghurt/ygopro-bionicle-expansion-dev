--Krana Ca. Clearance Worker
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)
Debug.AddCard(10100212,0,0,LOCATION_HAND,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100212,0,0,LOCATION_GRAVE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100201,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(10100201,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK)
Debug.AddCard(10100201,0,0,LOCATION_DECK,3,POS_FACEUP_ATTACK)
Debug.AddCard(89631139,0,0,LOCATION_MZONE,4,POS_FACEUP_ATTACK)
Debug.AddCard(89631139,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(4035199,1,1,LOCATION_MZONE,3,POS_FACEUP_ATTACK)
Debug.AddCard(44095762,1,1,LOCATION_SZONE,2,POS_FACEDOWN_ATTACK)
Debug.ReloadFieldEnd()
