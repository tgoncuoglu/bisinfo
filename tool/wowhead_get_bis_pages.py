import os
import re
import shutil
import yaml
from typing import Union, Dict, Any

from selenium import webdriver

from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By

from texttable import Texttable


def recreate_folder(name: str):
    if (name is not None) and (name != ""):
        if os.path.exists(name):
            shutil.rmtree(name)
        os.mkdir(name)


def extract_item_info(href: str) -> Union[str, str]:
    itemId = ""
    bonus = ""
    item_pattern = (
        r"""https:\/\/www\.wowhead\.com\/item=(\d+)\/[a-zA-Z-]+\?bonus=([0-9:]+)"""
    )
    match = re.match(pattern=item_pattern, string=href, flags=re.IGNORECASE)
    if match:
        if len(match.group()) >= 3:
            itemId = int(match.group(1))
            bonus = match.group(2)
    return itemId, bonus


def extract_source(cell) -> str:
    result = ""
    try:
        link = cell.find_element(By.TAG_NAME, "a")
        if link:
            span = link.find_element(By.TAG_NAME, "span")
            if span:
                result = span.get_attribute("innerHTML")
    except:
        pass
    return result


def save_web_page(classname: str, spec: str, source: str) -> None:
    filename = f"pages/{classname}_{spec}.html".replace(" ", "_")
    with open(file=filename, mode="w") as fp:
        fp.write(source)


def save_class_yaml(classname: str, spec: str, data: Dict[str, Any]) -> None:
    """"""
    filename = f"data/{classname}_{spec}.yml".replace(" ", "_")
    with open(file=filename, mode="w") as fp:
        yaml.dump(
            data,
            fp,
            Dumper=yaml.SafeDumper,
            default_flow_style=False,
            sort_keys=False,
        )




options = webdriver.ChromeOptions()
proxy = "172.25.64.1:1080"
options.add_argument("--proxy-server=socks5://" + proxy)
options.add_argument("--blink-settings=imagesEnabled=false")

driver = webdriver.Chrome(options=options)

driver.get("https://wowhead.com")


classlist = driver.find_element(
    By.CLASS_NAME, "news-content-spotlight-class-guides-icons"
)
icons = classlist.find_elements(By.TAG_NAME, "a")
specs = []
for icon in icons:
    classspec = icon.get_attribute("aria-label")
    if classspec != "":
        spec, _, classname = classspec.partition(" ")
        link = icon.get_attribute("href")
        if (spec == "Hunter Beast") and (classname == "Mastery"):
            spec = "Beast Mastery"
            classname = "Hunter"
        specs.append([classname.strip(), spec.strip(), link.strip()])
specs.sort()

recreate_folder("pages")
recreate_folder("data")

bisdata = {}
newspecs = []
for spec in specs:
    driver.get(spec[2])
    bislink = driver.find_element(By.LINK_TEXT, "Gear")
    if bislink is not None:
        href = bislink.get_attribute("href")
        spec.append(href)
        newspecs.append(spec)
        driver.get(href)

        save_web_page(spec[0], spec[1], driver.page_source)

        slots = {}
        rows = driver.find_elements(
            By.XPATH,
            "//div[@id='tab-bis-items-mythic']/div[@class='wh-center']/table[@class='grid']/tbody/tr",
        )
        for row in rows[1:]:
            slotitem = {}
            cells = row.find_elements(By.TAG_NAME, "td")
            if len(cells) == 3:
                slot = cells[0].get_attribute("innerHTML")
                itemlink = cells[1].find_element(By.TAG_NAME, "a")
                itemname = ""
                if itemlink is not None:
                    bonus = itemlink.get_attribute("rel")
                    href = itemlink.get_attribute("href")
                    itemimg = itemlink.find_element(By.TAG_NAME, "img")
                    if itemimg is not None:
                        itemname = itemimg.get_attribute("alt")
                # source = cells[2].get_attribute("text")
                itemId, bonus = extract_item_info(href)
                source = extract_source(cells[2])
                slots[slot] = {
                    "name": itemname,
                    # "href": href,
                    "itemId": itemId,
                    "bonus": bonus,
                    "source": source,
                }

        specdict = {
            "class": spec[0],
            "spec": spec[1],
            "slots": slots
        }
        if spec[0] not in bisdata.keys():
            bisdata[spec[0]] = {}
        # if spec[1] not in bisdata[spec[0]].keys():
        bisdata[spec[0]][spec[1]] = specdict

        save_class_yaml(spec[0], spec[1], specdict)


with open(file="bisdata.yml", mode="w") as fp:
    yaml.dump(
        bisdata,
        fp,
        Dumper=yaml.SafeDumper,
        default_flow_style=False,
        sort_keys=False,
    )



tbl = Texttable()
tbl.add_row(["Class", "Spec", "Link", "BiS Link"])
tbl.add_rows(newspecs)
print(tbl.draw())
