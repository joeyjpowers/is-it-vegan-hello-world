#API KEY: W2Jb0QBbdzQIC9dTob2MsQ2Io2bN8rJFxCTTxMw6
#milk upc: 021130073719

require 'sinatra'
#require 'sinatra/reloader'
require 'httparty'

fruits_and_veggies = ["alfalfa sprouts",
"apple",
"apricot",
"artichoke",
"asian pear",
"asparagus",
"atemoya",
"avocado",
"bamboo shoots",
"banana",
"bean sprouts",
"beans",
"beets",
"belgian endive",
"bell peppers",
"bitter melon",
"blackberries",
"blueberries",
"bok choy",
"boniato",
"boysenberries",
"broccoflower",
"broccoli",
"brussels sprouts",
"cabbage",
"cactus pear",
"cantaloupe",
"carambola",
"carrots",
"casaba melon",
"cauliflower",
"celery",
"chayote",
"cherimoya",
"cherries",
"coconuts",
"collard greens",
"corn",
"cranberries",
"cucumber",
"dates",
"dried plums",
"eggplant",
"endive",
"escarole",
"feijoa",
"fennel",
"figs",
"garlic",
"gooseberries",
"grapefruit",
"grapes",
"green beans",
"green onions",
"greens",
"guava",
"hominy",
"honeydew melon",
"horned melon",
"iceberg lettuce",
"jerusalem artichoke",
"jicama",
"kale",
"kiwifruit",
"kohlrabi",
"kumquat",
"leeks",
"lemons",
"lettuce",
"lima beans",
"limes",
"longan",
"loquat",
"lychee",
"madarins",
"malanga",
"mandarin oranges",
"mangos",
"mulberries",
"mushrooms",
"napa",
"nectarines",
"okra",
"onion",
"oranges",
"papayas",
"parsnip",
"passion fruit",
"peaches",
"pears",
"peas",
"peppers",
"persimmons",
"pineapple",
"plantains",
"plums",
"pomegranate",
"potato",
"potatoes",
"prickly pear",
"prunes",
"pummelo",
"pumpkin",
"quince",
"radicchio",
"radishes",
"raisins",
"raspberries",
"red cabbage",
"rhubarb",
"romaine lettuce",
"rutabaga",
"shallots",
"snow peas",
"spinach",
"sprouts",
"squash",
"strawberries",
"string beans",
"sweet potato",
"tangelo",
"tangerines",
"tomatillo",
"tomato",
"turnip",
"ugli fruit",
"water chestnuts",
"watercress",
"watermelon",
"waxed beans",
"yams",
"yellow squash",
"yuca",
"cassava",
"zucchini squash"]

get '/' do
@error = params[:error];
erb :get_page
end

post '/' do
@entry = params[:desc].lstrip.rstrip.downcase
@food = ""
in_list = false
for food in fruits_and_veggies
    if @entry == food
        in_list = true
    end
end

url = 'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=W2Jb0QBbdzQIC9dTob2MsQ2Io2bN8rJFxCTTxMw6&query='
url = url + @entry + "&dataType=Branded"
response = HTTParty.get(url)
@result = response.parsed_response
if @result['totalHits'] == 0
        @entry = '00' + @entry
        url = 'https://api.nal.usda.gov/fdc/v1/foods/search?api_key=W2Jb0QBbdzQIC9dTob2MsQ2Io2bN8rJFxCTTxMw6&query='
        url = url + @entry + "&dataType=Branded"
        response = HTTParty.get(url)
        @result = response.parsed_response
end
if @result['totalHits'] == 0
        @result = 'There are zero hits'
        
else
        if !in_list
            @food = @result['foods'][0]['description']
        else
            @food = @entry.upcase
        end
        if @result['foods'][0]['ingredients'] == ""
                @result = @entry + '.'
        else
                @result = @result['foods'][0]['ingredients'].downcase
        end
        if @result.include? " and "
                @result = @result.gsub!(" and ", ", ")
        end
        if @result.include? "contains 2% or less of the following: "
                @result = @result.gsub!("contains 2% or less of the following: ", "")
        end
        if @result.include? "contains 2% or less of "
                @result = @result.gsub!("contains 2% or less of ", "")
        end
        @result.gsub!(/[^0-9a-zA-Z,\- ]/, '')
        ingredients = @result.split(', ')
       
        if !in_list
            resultString = ""
            for i in 0...ingredients.length-1
                if (i != ingredients.length - 1)
                    resultString += ingredients[i] + ", "
                else
                    resultString += ingredients[i]
                end
            end
            @result = resultString
            @ingredientTag = "Ingredients:"
        else
            @result = ""
            @ingredientTag = ""
        end
        #traversing the various arrays to see if item is vegan
        
        maybe_vegan_ingredients = ["allantoin",
            "alphahydroxyacids",
            "aminoacids",
            "biotin",
            "calcium carbonate",
            "calcium lactate",
            "calcium stearate",
            "carbonblack",
            "cetylalcohol",
            "cetylpalmitate",
            "chalk",
            "charcoal",
            "cholecalciferol",
            "chymosin",
            "civet",
            "corticosteroid",
            "cortisone",
            "dexpanthenol",
            "disodiuminosinate",
            "e129",
            "e133",
            "e170",
            "e322",
            "e470",
            "e570",
            "e585",
            "e631",
            "e640",
            "e901",
            "e910",
            "e920",
            "enzymes",
            "gluconolactone",
            "glucosamine",
            "glycerol",
            "glycine",
            "inositol",
            "insulin",
            "insulin",
            "lactic acid from whey",
            "lecithin",
            "lecithin",
            "lipoids",
            "magnesium lanolate",
            "magnesium tallowate",
            "mono-diglycerides",
            "musk",
            "natural flavor",
            "oestrogen",
            "oleicacid",
            "oleicalcohol",
            "oleth",
            "peg",
            "peg-13 hydrogenated tallow amide",
            "peg-15 tallow polyamine",
            "peg-2 milk solids",
            "peg-20 tallowate",
            "peg-28 glyceryl tallowate",
            "peg-75 lanolin oil and wax",
            "peg-8 hydrogenated fish glycerides",
            "polysorbates",
            "potassium lactate",
            "progesterone",
            "progesterone",
            "propyleneglycol",
            "quinoline yellow",
            "red 40",
            "rennet",
            "rennin",
            "sorbitan beeswax",
            "sorbitanmonooleate",
            "sorbitanmonostearate",
            "sorbitantrioleate",
            "sorbitantristearate",
            "sponge",
            "squalane",
            "squalane",
            "squalene",
            "stearate",
            "stearate",
            "stearate",
            "stearicacid",
            "stearin",
            "stearin",
            "stearyl alcohol",
            "stearyl alcohol",
            "stearyltartrate",
            "steroid",
            "sterol",
            "suede",
            "suet",
            "sunset yellow fcf",
            "tallow aminopropylamine",
            "tartrazine",
            "taurine",
            "testosterone",
            "vellum",
            "velvet",
            "vitamin a",
            "vitamin a",
            "vitamin b1",
            "vitamin b12",
            "vitamin d3",
            "yellow5",
            "yellow6"]
        
        non_vegan_ingredients = ["abalone",
            "acetate",
            "acetylated hydrogenated lard glyceride",
            "acetylated lanolin",
            "acetylated lanolin alcohol",
            "acetylated lanolin ricinoleate",
            "acetylated tallow",
            "acid",
            "acidophilus milk",
            "adrenaline",
            "adrenals of cattle",
            "adrenals of hogs",
            "adrenals of sheep",
            "afterbirth",
            "alanine",
            "albumen",
            "albumin",
            "alcloxa",
            "aldioxa",
            "aliphatic alcohol",
            "allantoin",
            "alligator",
            "alligator skin",
            "alpha-hydroxy acids",
            "ambergris",
            "amerachol",
            "amerchol l101",
            "aminiuccinate acid",
            "amino acids",
            "aminosuccinate acid",
            "ammonium caseinate",
            "ammonium hydrolyzed protein",
            "amniotic fluid",
            "ampd isoteric hydrolyzed animal protein",
            "amylase",
            "anchovies",
            "anchovy",
            "angora",
            "animal bones",
            "animal collagen amino acids",
            "animal fat",
            "animal fats and oils",
            "animal hair",
            "animal keratin amino acids",
            "animal oil",
            "animal placenta",
            "animal protein derivative",
            "animal tissue extract",
            "arachidonic acid",
            "arachidyl proprionate",
            "aspartic acid",
            "aspic",
            "astrakhan",
            "back bacon",
            "back fat",
            "bacon",
            "bass",
            "batyl alcohol",
            "batyl isostearate",
            "bear",
            "bee pollen",
            "bee products",
            "beef",
            "beef heart",
            "beef liver",
            "beef tongue",
            "beepollen",
            "beeswax",
            "beeswax honeycomb",
            "belly bacon",
            "benzyltrimonium hydrolyzed animal protein",
            "biotin vitamin h vitamin b factor",
            "bison",
            "blood",
            "blood plasma fractionation",
            "blood tongue",
            "boar bristles",
            "boiled ham",
            "bone ash",
            "bone char",
            "bone char(coal)/boneblack",
            "bone charcoal",
            "bone earth",
            "bone meal",
            "bone phosphate",
            "bone soup",
            "bone/bonemeal",
            "boneblack",
            "bonito",
            "bovine serum albumin",
            "brain extract",
            "bratwurst",
            "brawn",
            "breakfast bacon",
            "bresaola",
            "bristle",
            "bruehwurst",
            "buffalo",
            "buffalo milk",
            "bushmeat",
            "butter",
            "butter fat",
            "butter solids",
            "buttermilk",
            "buttermilk powder",
            "c30-46 piscine oil",
            "calamari",
            "calciferol",
            "calciferool",
            "calcium caseinate",
            "calf liver",
            "calfskin",
            "calfskin extract",
            "camel milk",
            "canadian bacon",
            "cantharides tincture",
            "capiz",
            "capryl betaine",
            "caprylamine oxide",
            "caprylic acid",
            "caprylic triglyceride",
            "carbamide",
            "caribou",
            "carmine",
            "carmine cochineal carminic acid",
            "carmine/carminic acid",
            "carmine: cochineal. carminic acid",
            "carminic",
            "carminic acid",
            "carotene provitamin a beta carotene",
            "carp",
            "casein",
            "casein caseinate sodium caseinate",
            "caseinate",
            "caseinogen",
            "cashmere",
            "castor castoreum",
            "castoreum",
            "catfish",
            "catgut",
            "catharidin",
            "caviar(e)",
            "cera flava",
            "cerebrosides",
            "certain additives",
            "ceteth-02",
            "ceteth-1",
            "ceteth-10",
            "ceteth-2",
            "ceteth-30",
            "ceteth-4",
            "ceteth-6",
            "cetyl alcohol",
            "cetyl lactate",
            "cetyl myristate",
            "cetyl palmitate",
            "chamois",
            "cheese",
            "chicken",
            "chicken breast",
            "chicken liver",
            "chicken loaf",
            "chipped ham",
            "chitin",
            "chitosan",
            "cholecalciferol",
            "cholesterin",
            "cholesterol",
            "choline bitartrate",
            "chondroitin",
            "chopped ham",
            "chorizo",
            "chymotrypsin",
            "civet",
            "clarified butter",
            "clotted cream",
            "cochineal",
            "cod",
            "cod liver oil",
            "cold cuts",
            "coleth-24",
            "collagen",
            "collagen hydrolysate",
            "colors dyes",
            "condensed milk",
            "confectioners glaze",
            "cooked ham",
            "cooked meats",
            "coral",
            "corned beef",
            "cornish game hen",
            "cortico steroid",
            "corticosteroid",
            "cortisone",
            "cortisone corticosteroid",
            "cortisone: see cortico steroid.",
            "cotechino",
            "cottage cheese",
            "crab",
            "crabmeat",
            "crawfish",
            "crayfish",
            "cream",
            "crustacean shellfish",
            "curds",
            "custard",
            "cysteine, l-form",
            "cystine",
            "dark meat",
            "dashi",
            "dea-oleth-10 phosphate",
            "deer",
            "deer meat",
            "delactosed whey",
            "deli meats",
            "demineralized whey",
            "deoxyribonucleic acid",
            "desamido animal collagen",
            "desamidocollagen",
            "devon",
            "dexpanthenol",
            "dicapryloyl cystine",
            "diethylene tricaseinamide",
            "diglycerides",
            "dihydrocholesterol",
            "dihydrocholesterol octyledecanoate",
            "dihydrocholeth-15",
            "dihydrocholeth-30",
            "dihydrogenated tallow benzylmoniumchloride",
            "dihydrogenated tallow methylamine",
            "dihydrogenated tallow phthalate",
            "dihydroxyethyl tallow amine oxide",
            "dimethyl hydrogenated tallowamine",
            "dimethyl stearamine",
            "dimethyl tallowamine",
            "disodium hydrogenatedtallowglutamate",
            "disodium tallamido mea-sulfosuccinate",
            "disodium tallowaminodipropionate",
            "ditallowdimonium chloride",
            "dna",
            "down",
            "dried buttermilk",
            "dried egg yolk",
            "dry milk solids",
            "dry whole milk",
            "duck",
            "duck bacon",
            "duck liver",
            "duodenum substances",
            "dutch loaf",
            "dyes",
            "e120",
            "e441",
            "e542",
            "e904",
            "e913",
            "edible bone phosphate",
            "egg",
            "egg albumen",
            "egg albumen/albumin",
            "egg oil",
            "egg powder",
            "egg protein",
            "egg whites",
            "egg yolk",
            "egg yolk extract",
            "egg yolks",
            "eggs",
            "elastin",
            "elk bacon",
            "embryo extract",
            "emu",
            "emu oil",
            "epiderm oil r",
            "ergisterol",
            "ergocalciferol",
            "ergosterol",
            "estradiol",
            "estradiol benzoate",
            "estrogen",
            "estrogen estradiol",
            "estrogen/estradiol",
            "estrone",
            "ethyl ester of hydrolyzed animal protein",
            "ethyl morrhuatelipineate",
            "ethylarachidonate",
            "ethylene dehydrogenated tallowamide",
            "evaporated milk",
            "ewe milk",
            "fat-free milk",
            "fat-free yogurt",
            "fats",
            "fatty acids",
            "fd and c colors",
            "feathers",
            "felt",
            "fermented camel milk",
            "fermented cream",
            "fermented milk",
            "fish",
            "fish glycerides",
            "fish liver",
            "fish liver oil",
            "fish livers",
            "fish oil",
            "fish sauce",
            "fish scales",
            "fishsauce",
            "fletan oil",
            "fur",
            "gel",
            "gelatin",
            "gelatin gel",
            "gelatin(e)",
            "gelbwurst",
            "ghee",
            "gizzards",
            "glucosamine",
            "glucose tyrosinase",
            "glucuronic acid",
            "glutamic acid",
            "glycerides",
            "glycerin glycerol",
            "glycerol",
            "glyceryl lanolate",
            "glyceryls",
            "glycogen",
            "glycreth-26",
            "goat",
            "goat cheese",
            "goat milk",
            "goose",
            "goose insulating feathers",
            "goose liver",
            "grade a milk",
            "ground beef",
            "grouse",
            "guanine",
            "guanine pearl essence",
            "guanine/pearl essence",
            "guinea hen",
            "gypsy bacon",
            "haddock",
            "hair from hogs",
            "halibut",
            "ham",
            "ham and cheese loaf",
            "head cheese",
            "heavy cream",
            "heptylundecanol",
            "hide",
            "hide glue",
            "homogenized milk",
            "honey",
            "honeycomb",
            "horse",
            "horse hair",
            "horseflesh",
            "horsehair",
            "hot dog",
            "human placental protein",
            "human umbilical extract",
            "hyaluronic acid",
            "hydrlyzed human placental protein",
            "hydrocortisone",
            "hydrogenated animal glyceride",
            "hydrogenated ditallow amine",
            "hydrogenated honey",
            "hydrogenated laneth-20",
            "hydrogenated laneth-25",
            "hydrogenated laneth-5",
            "hydrogenated lanolin",
            "hydrogenated lanolin alcohol",
            "hydrogenated lard glyceride",
            "hydrogenated shark-liver oil",
            "hydrogenated tallow acid",
            "hydrogenated tallow betaine",
            "hydrogenated tallow glyceride",
            "hydrolyzed animal elastin",
            "hydrolyzed animal keratin",
            "hydrolyzed animal protein",
            "hydrolyzed casein",
            "hydrolyzed elastin",
            "hydrolyzed keratin",
            "hydrolyzed milk protein",
            "hydrolyzed silk",
            "hydroxylated lanolin",
            "ice cream",
            "imidazolidinyl urea",
            "insulin",
            "iron caseinate",
            "isinglass",
            "isobutylated lanolin",
            "isopropyl lanolate",
            "isopropyl myristate",
            "isopropyl tallowatelsopropyl lanolate",
            "isopropylpalmitate",
            "isostearic hydrolyzed animal protein",
            "isostearoyl hydrolyzed animal protein",
            "jagdwurst",
            "jowl",
            "kangaroo",
            "katsuobushi (okaka)",
            "keratin",
            "keratinamino acids",
            "l-cysteine",
            "l-form",
            "l-form: see cysteine.",
            "l-lactic acid",
            "lacotse-reduced milk",
            "lactalbumin",
            "lactic yeasts",
            "lacticacid",
            "lactoferrin",
            "lactoglobulin",
            "lactose",
            "lactose-free milk",
            "lactulose",
            "lamb",
            "lamb bacon",
            "laneth",
            "laneth-10",
            "laneth-11",
            "laneth-12",
            "laneth-13",
            "laneth-14",
            "laneth-15",
            "laneth-16",
            "laneth-17",
            "laneth-18",
            "laneth-19",
            "laneth-20",
            "laneth-21",
            "laneth-22",
            "laneth-23",
            "laneth-24",
            "laneth-25",
            "laneth-26",
            "laneth-27",
            "laneth-28",
            "laneth-29",
            "laneth-30",
            "laneth-31",
            "laneth-32",
            "laneth-33",
            "laneth-34",
            "laneth-35",
            "laneth-36",
            "laneth-37",
            "laneth-38",
            "laneth-39",
            "laneth-40",
            "laneth-5",
            "laneth-6",
            "laneth-7",
            "laneth-8",
            "laneth-9",
            "laneth-9 acetate",
            "laneth10 acetate",
            "lanogene",
            "lanoinamidedea",
            "lanolin",
            "lanolin acid",
            "lanolin acid: see lanolin.",
            "lanolin alcohol",
            "lanolin alcohols",
            "lanolin alcohols: see lanolin.",
            "lanolin lanolin acids wool fat wool wax",
            "lanolin linoleate",
            "lanolin oil",
            "lanolin ricinoleate",
            "lanolin wax",
            "lanolin(e)",
            "lanolin: lanolin acid",
            "lanosterol",
            "lanosterol: see lanolin.",
            "lanosterols",
            "lard",
            "lard glyceride",
            "lauroyl hydrolyzed animal protein",
            "leather",
            "leather suede calfskin sheepskinalligator skin other types of skin",
            "lecithin cholinebitartrate",
            "leucine",
            "linoleic acid",
            "lipase",
            "lipids",
            "lipoids lipids",
            "liver",
            "liver extract",
            "liverwurst",
            "lobster",
            "low fat milk",
            "low fat yogurt",
            "lunasponge",
            "luncehon loaf",
            "lunch meats",
            "luncheon meats",
            "lysine",
            "mackerel",
            "magnesium caseinate",
            "malted milk",
            "mammarian extract",
            "marine oil",
            "marrow soup",
            "mayonnaise",
            "mea-hydrolyzed animal protein",
            "meat",
            "meat loaf",
            "meatball",
            "mechanically separated chicken",
            "methionine",
            "mettwurst",
            "milk",
            "milk chocolate",
            "milk derivative",
            "milk of mammals",
            "milk protein",
            "milk skin",
            "milk sugar",
            "milkfat",
            "milkpowder",
            "minced beef",
            "minced meat",
            "mink oil",
            "minkamidopropyl diethylamine",
            "mohair",
            "molluscan shellfish",
            "monkfish",
            "mono and di-glycerides",
            "monoglycerides glycerides",
            "monoglycerides glycerides (see glycerin)",
            "moose",
            "mortadella",
            "mossbunker oil",
            "mullet",
            "muscle extract",
            "musk",
            "musk (oil)",
            "musk ambrette",
            "mussel",
            "mussels",
            "mutton",
            "myristal ether sulfate",
            "myristate acid",
            "myristic acid",
            "myristoyl hydrolyzed animal protein",
            "myristyl",
            "myristyls",
            "natural butter flavor",
            "natural flavorings",
            "natural red 4",
            "natural sources",
            "neck",
            "nonfat milk",
            "note:",
            "nougat",
            "nucleicacids",
            "ocenol",
            "octopus",
            "octyl dodecanol",
            "oils",
            "oleamidopropyl dimethylamine hydrolyzed animal protein",
            "oleic acid",
            "oleoic oil",
            "oleostearin",
            "oleostearine",
            "oleoyl hydrolyzed animal protein",
            "oleths",
            "oleyl arachidate",
            "oleyl betatine",
            "oleyl imidazoline",
            "oleyl lanolate",
            "oleyl myristate",
            "oleyl oleate",
            "oleyl stearate",
            "oleylalcohol ocenol",
            "oleylimidazoline",
            "omega-3 fatty acids",
            "opossum",
            "organ meat",
            "organ meats",
            "organs",
            "ostrich",
            "ovalbumin",
            "ovarian extract",
            "ox bile",
            "oxgall",
            "oyster",
            "palmitamide",
            "palmitamine",
            "palmitate",
            "palmitic acid",
            "palmitoyl hydrolyzed milk protein",
            "palmitoyl hydrolyzedanimal protein",
            "pancetta",
            "panthenol dexpanthenol vitamin b-complex factor provitamin b-5",
            "panthenyl",
            "paracasein",
            "partridge",
            "pasteurized milk",
            "pearl",
            "pearl essence",
            "pentahydrosqualene",
            "pepsin",
            "perhydrosqualene",
            "pharmaceutical glaze",
            "pheasant",
            "picnic shoulder",
            "pigskin extract",
            "placenta",
            "placenta placenta polypeptides protein afterbirth",
            "placenta polypeptides protein",
            "placental enzymes",
            "placental extract",
            "placental protein",
            "plaice",
            "pogy oil",
            "pollock",
            "poltethylene cetyl ether",
            "polyglycerol",
            "polyglyceryl-2lanolin alcohol ether",
            "polypeptides",
            "polypeptides protein",
            "polysorbates",
            "polytetylene glycerol/glycol/peg",
            "porcine pancreas",
            "pork",
            "pork fat",
            "pork roll",
            "potassium caseinate",
            "potassium tallowate",
            "potassium undecylenoyl hydrolyzed animal protein",
            "poultry",
            "ppg-12-peg-50 lanolin",
            "ppg-2,-5, -10. -20, -30 lanolinalcohol ethers",
            "ppg-30 lanolin ether",
            "prawn",
            "pregnenolone acetate",
            "pristane",
            "progesterone",
            "propolis",
            "prosciutto",
            "provitamin a",
            "provitamin b-5",
            "provitamin d-2",
            "purcelline oil syn",
            "quail",
            "quaternium 27",
            "rabbit",
            "red meat",
            "reduced fat milk",
            "reduced fat yogurt",
            "rennet",
            "rennet casein",
            "rennet rennin",
            "rennin",
            "resinous glaze",
            "reticulin",
            "retinol",
            "ribonucleic acid",
            "rna ribonucleic acid",
            "roast beef",
            "roast pork",
            "roe",
            "royal jelly",
            "sable",
            "sable brushes",
            "saccharide hydrolysate",
            "saccharide isomerate",
            "salami",
            "salceson",
            "salmon",
            "sardine",
            "sausage",
            "sausages",
            "scallop",
            "scallops",
            "sea sponge",
            "sea turtle oil",
            "seasponge",
            "serum albumin",
            "serum proteins",
            "shark liver oil",
            "shark-liver oil",
            "sheep milk",
            "sheepskin",
            "shellac",
            "shellac resinous glaze",
            "shellac wax",
            "shoulder",
            "shrimp",
            "shrimph",
            "side bacon",
            "silk",
            "silk amino acids",
            "silk powder",
            "silk silk powder",
            "skim milk",
            "slab bacon",
            "sliced meats",
            "smoked ham",
            "snail",
            "snails",
            "snake",
            "snapper",
            "sodium / tea-lauroyl hydrolyzed animal protein",
            "sodium / tea-undecylenoyl hydrolyzed animal protein",
            "sodium caseinate",
            "sodium coco-hydrolyzed animal protein",
            "sodium soya hydrolyzed animal protein",
            "sodium tallow sulfate",
            "sodium tallowate",
            "sodium undecylenate",
            "sodiumsteroyl lactylate",
            "soluble  collagen",
            "sour cream",
            "sour milk",
            "sour milk solids",
            "soured milk",
            "soya hydroxyethyl imidazoline",
            "sperm oil",
            "sperm whale intestines",
            "spermaceti",
            "spermaceticetyl palmitate sperm oil",
            "spleen extract",
            "sponge (luna and sea)",
            "squab",
            "squalane",
            "squalene",
            "squid",
            "squirrel",
            "steak",
            "stearamide",
            "stearamine",
            "stearamine oxide",
            "stearates",
            "stearic acid",
            "stearic hydrazide",
            "stearin",
            "stearone",
            "stearoxytrimethylsilane",
            "stearoyl lactylic acid",
            "stearyl acetate",
            "stearyl alcohol sterols",
            "stearyl betaine",
            "stearyl caprylate",
            "stearyl citrate",
            "stearyl glycyrrhetinate",
            "stearyl heptanoate",
            "stearyl imidazoline",
            "stearyl octanoate",
            "stearyl stearate",
            "stearyldimethyl amine",
            "steroids sterols",
            "sterols",
            "stewing steak",
            "stilton",
            "streaky bacon",
            "suede",
            "sweet dairy whey",
            "sweet whey",
            "sweetbreads",
            "sweetened condensed milk",
            "swordfish",
            "tallow",
            "tallow acid",
            "tallow amide",
            "tallow amine",
            "tallow amine oxide",
            "tallow fatty alcohol",
            "tallow glycerides",
            "tallow hydroxyethal imidazoline",
            "tallow imidazoline",
            "tallow tallow fatty alcohol stearic acid",
            "tallow trimonium chloride - tallow",
            "tallowamidopropylamine oxide",
            "talloweth-6",
            "tallowmide dea and mea",
            "tallowmidopropyl hydroxysultaine",
            "tallowminopropylamine",
            "tallowmphoacete",
            "tea-abietoyl hydrolyzedanimal protein",
            "tea-coco hydrolyzed animal protein",
            "tea-lauroyl animal collagen amino acids",
            "tea-lauroyl animal keratin amino acids",
            "tea-myristol hydrolyzed animal protein",
            "tea-undecylenoyl hydrolyzed animal protein",
            "testicular extract",
            "threonine",
            "thuringian sausage",
            "tilapia",
            "tongue",
            "triethonium hydrolyzed animal protein ethosulfate",
            "trilaneth-4phosphate",
            "tripe",
            "triterpene alcohols",
            "trout",
            "trypsin",
            "tuna",
            "turkey",
            "turkey bacon",
            "turkey breast",
            "turtle",
            "turtle oil",
            "sea turtle oil",
            "tyrosine",
            "un-homogenized milk",
            "urea",
            "urea carbamide",
            "uric acid",
            "uric acid from cows",
            "uricacid",
            "urine",
            "veal",
            "veal loaf",
            "venison",
            "vitamin a",
            "vitamin b-complex factor",
            "vitamin d ergocalciferol vitamin d",
            "vitamin d3",
            "vitamin h",
            "vitaminb",
            "vitaminb factor",
            "volaise",
            "whey",
            "whey powder",
            "whey protein",
            "whipped cream",
            "whipped topping",
            "white meat",
            "whole milk",
            "whole milk yogurt",
            "wild boar",
            "wild meat",
            "wool",
            "wool fat",
            "wool wax",
            "wool wax alcohols",
            "yoghurt",
            "yogurt",
            "zinc caseinate",
            "zinc hydrolyzed animal protein"]
        
        is_vegan = false
        is_not_vegan = false
        is_unsure = false
        
        for ingredient in ingredients
            item_maybe_vegan = false
            item_not_vegan = false
            for non_vegan_item in non_vegan_ingredients
                if ingredient == non_vegan_item
                    item_not_vegan = true
                    is_not_vegan = true
                    break
                end
            end
            for maybe_vegan_item in maybe_vegan_ingredients
                if ingredient == maybe_vegan_item
                    item_maybe_vegan = true
                    is_unsure = true
                end
            end
            if item_maybe_vegan == false && item_not_vegan == false
                is_vegan = true
            end
        end
        
        if is_not_vegan == false && is_unsure == false
            is_vegan = true
        end
        
        if in_list == true
            @result1 = "This item is vegan!"
        elsif is_not_vegan == true
            @result1 = "This item is not vegan!"
        elsif is_unsure == true
            @result1 = "We are not sure if this item is vegan!"
        elsif is_vegan == true 
            @result1 = "This item is vegan!"
        else
            @result1 = "Something has gone terribly wrong!"
        end
    end
    


    erb :get_page
end
__END__

@@get_page
<!DOCTYPE html>
<html lang="en">

<head>
	<title>Is It Vegan?</title>
	<link rel="stylesheet" type="text/css" href="Index_Stylesheet.css">
    <meta charset="utf-8">
</head>

<body>
	<header>
        <h1>Is It Vegan?</h1>
        <p>
        Wondering if what you want to eat meets your vegan diet?
        <br>
        Input a food item or UPC number below and we'll let you know if it's vegan.
        <br>
        <span style="font-style: italic;">Note that UPC numbers provide more specific results, so we recommend using a UPC number if available.</span>
        </p>
    </header>
    
    <form action="/", method = "post">
        <input type="text" placeholder="Food item or UPC #" required id="food", name="desc"/>
        <br>
        <button id="submit">Check If Vegan...</button>
    </form>
        <div><p id="result"><%= @result1 %></p></div>
        <div><p id="result"><%= @ingredientTag %></p></div>
        <div><p id="result"><%= @result %></p></div>
        <div><p id="food"><%= @food %></p></div>
 </body>
 


