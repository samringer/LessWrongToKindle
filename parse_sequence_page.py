import requests
import shutil
import re
from bs4 import BeautifulSoup
from argparse import ArgumentParser


def main(path):
    page = requests.get(path)

    soup = BeautifulSoup(page.content, 'html.parser')

    posts = soup.find_all('span', {'class' : 'PostsTitle-root'})
    posts_info = {}
    links = []
    for post in posts:
        link_path = post.find('a', href=True)
        # Assumes this is coming from less wrong
        link = "https://www.lesswrong.com" + link_path['href']
        links.append(link)

    shutil.copy("sequence_template.yml", "output.yml")
    with open("output.yml", "a+") as out_f:
        for link in links:
            string = "- " + link +"\n"
            out_f.write(string)

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument('path')
    args = parser.parse_args()
    main(args.path)
