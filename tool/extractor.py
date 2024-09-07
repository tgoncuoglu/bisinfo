import re

pattern = r"""<tr><td>([a-zA-Z0-9 ]+)</td><td><a rel=\"\S+\" class=\"\S+ \S+\" data-game=\"\S+\" data-type=\"\S+\" data-entity=\"\S+\" href=\"https:\/\/www\.wowhead\.com\/item=(\d+)\/\S+\?bonus=(\S+)\" data-entity-has-icon=\"\S+\"><img alt=\"[a-zA-Z0-9 '.\-]+\" src=\"\S+\" loading=\"\S+\" style=\"[a-zA-Z0-9.:;\- ]*\"> <span class=\"\S+\">([a-zA-Z0-9 '.\-]+)</span></a></td><td><a data-entity=\"\S+\" href=\"https:\/\/www\.wowhead\.com\/npc=(\d+)/\S+\"><span class=\"\S+\">([a-zA-Z0-9 '.\-]+)</span></a></td></tr>"""

with open(file="tool\\data.txt", mode="r") as fp:
    data = fp.read()

items = ["    elemental = {"]
trinketcount = 0
ringcount = 0
matches = re.findall(pattern=pattern, string=data, flags=re.IGNORECASE|re.MULTILINE)
for item in matches:
    slot = item[0]
    if slot == "Main Hand":
        slot = "MainHand"
    elif slot == "Off Hand":
        slot = "SecondaryHand"
    elif slot == "Trinket":
        slot = f"{slot}{trinketcount}"
        trinketcount += 1
    elif slot == "Ring":
        slot = f"{slot}{ringcount}"
        ringcount += 1
    line = f"""        {slot} = {{id = {item[1]}, source = "wowhead", sourceset = "Overall BiS", dropsfrom = "{item[5]}", name = "{item[3]}", bonus = "{item[2]}"}},"""
    items.append(line)
items.append("},")

lines = "\n".join(items)
print(lines)

