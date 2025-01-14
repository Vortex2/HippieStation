

//Values for antag preferences, event roles, etc. unified here



//These are synced with the Database, if you change the values of the defines
//then you MUST update the database!
#define ROLE_SYNDICATE			"Syndicate"
#define ROLE_TRAITOR			"Traitor"
#define ROLE_OPERATIVE			"Operative"
#define ROLE_CHANGELING			"Changeling"
#define ROLE_WIZARD				"Wizard"
#define ROLE_MALF				"Malf AI"
#define ROLE_REV				"Revolutionary"
#define ROLE_REV_HEAD			"Head Revolutionary"
#define ROLE_ALIEN				"Xenomorph"
#define ROLE_PAI				"pAI"
#define ROLE_CULTIST			"Cultist"
#define ROLE_BLOB				"Blob"
#define ROLE_NINJA				"Space Ninja"
#define ROLE_MONKEY				"Monkey"
#define ROLE_ABDUCTOR			"Abductor"
#define ROLE_REVENANT			"Revenant"
#define ROLE_DEVIL				"Devil"
#define ROLE_SERVANT_OF_RATVAR	"Servant of Ratvar"
#define ROLE_BORER				"borer"
#define ROLE_BROTHER			"Blood Brother"
#define ROLE_BRAINWASHED		"Brainwashed Victim"
#define ROLE_OVERTHROW			"Syndicate Mutineer"
#define ROLE_HIVE				"Hivemind Host"
#define ROLE_OBSESSED				"Obsessed"
#define ROLE_SENTIENCE			"Sentience Potion Spawn"
#define ROLE_MIND_TRANSFER		"Mind Transfer Potion"
#define ROLE_POSIBRAIN			"Posibrain"
#define ROLE_DRONE				"Drone"
#define ROLE_DEATHSQUAD			"Deathsquad"
#define ROLE_LAVALAND			"Lavaland"
#define ROLE_INTERNAL_AFFAIRS	"Internal Affairs Agent"
#define ROLE_VAMPIRE			"vampire" // hippie -- adds vampire role
#define ROLE_SHADOWLING			"shadowling" // hippie -- adds shadowling role
#define ROLE_GANG				"gangster" // hippie -- adds gang related role
#define ROLE_INFILTRATOR		"syndicate infiltrator" // hippie -- adds infiltrator role
#define ROLE_KOTD				"Syndicate Recruit (KotD)" // hippie -- adds KotD role
#define ROLE_PILLARMEN 			"Pillar Man" // hippie -- adds pillar men

//Missing assignment means it's not a gamemode specific role, IT'S NOT A BUG OR ERROR.
//The gamemode specific ones are just so the gamemodes can query whether a player is old enough
//(in game days played) to play that role
GLOBAL_LIST_INIT(special_roles, list(
	ROLE_TRAITOR = /datum/game_mode/traitor,
	ROLE_BROTHER = /datum/game_mode/traitor/bros,
	ROLE_OPERATIVE = /datum/game_mode/nuclear,
	ROLE_CHANGELING = /datum/game_mode/changeling,
	ROLE_WIZARD = /datum/game_mode/wizard,
	ROLE_MALF,
	ROLE_REV = /datum/game_mode/revolution,
	ROLE_ALIEN,
	ROLE_PAI,
	ROLE_CULTIST = /datum/game_mode/cult,
	ROLE_BLOB,
	ROLE_NINJA,
	ROLE_OBSESSED,
	ROLE_MONKEY = /datum/game_mode/monkey,
	ROLE_REVENANT,
	ROLE_ABDUCTOR,
	ROLE_DEVIL = /datum/game_mode/devil,
	ROLE_BORER,
	ROLE_SERVANT_OF_RATVAR = /datum/game_mode/clockwork_cult,
	ROLE_OVERTHROW = /datum/game_mode/overthrow,
	ROLE_HIVE = /datum/game_mode/hivemind,
	ROLE_SENTIENCE,
	ROLE_INTERNAL_AFFAIRS = /datum/game_mode/traitor/internal_affairs,
	ROLE_SHADOWLING = /datum/game_mode/shadowling, // hippie -- adds shadowling role=gamemode
	ROLE_VAMPIRE = /datum/game_mode/vampire, // hippie -- adds vampire role=gamemode
	ROLE_GANG = /datum/game_mode/gang, // hippie -- adds gang role=gamemode
	ROLE_INFILTRATOR = /datum/game_mode/infiltration, // hippie -- adds infiltrator role=gamemode
	ROLE_KOTD = /datum/game_mode/traitor/kotd, // hippie -- adds KotD role=gamemode
	ROLE_PILLARMEN = /datum/game_mode/pillarmen // hippie -- adds pillar men role=gamemode
))

//Job defines for what happens when you fail to qualify for any job during job selection
#define BEOVERFLOW 	1
#define BERANDOMJOB 	2
#define RETURNTOLOBBY 	3
