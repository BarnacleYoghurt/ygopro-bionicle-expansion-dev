--Shadow Toa
Debug.SetAIName("Unit Test")
Debug.ReloadFieldBegin(DUEL_ATTACK_FIRST_TURN,4)
Debug.SetPlayerInfo(0,8000,0,0)
Debug.SetPlayerInfo(1,8000,0,0)
Debug.AddCard(10100162,0,0,LOCATION_HAND,2,0)
Debug.AddCard(89631139,0,0,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
local t=Debug.AddCard(27279764,0,0,LOCATION_MZONE,3,POS_FACEUP_ATTACK)
Debug.PreSummon(t,SUMMON_TYPE_NORMAL)
Debug.AddCard(10045474,0,0,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.AddCard(97268402,1,1,LOCATION_HAND,2,0)
Debug.AddCard(74615388,1,1,LOCATION_MZONE,0,POS_FACEUP_DEFENSE)
Debug.AddCard(10100002,1,1,LOCATION_MZONE,1,POS_FACEUP_ATTACK)
Debug.AddCard(82385847,1,1,LOCATION_MZONE,2,POS_FACEUP_ATTACK)
Debug.AddCard(11091375,1,1,LOCATION_MZONE,3,POS_FACEUP_DEFENSE)
Debug.AddCard(89631139,1,1,LOCATION_MZONE,4,POS_FACEUP_ATTACK)
Debug.AddCard(10045474,1,1,LOCATION_SZONE,2,POS_FACEDOWN)
Debug.ReloadFieldEnd()
