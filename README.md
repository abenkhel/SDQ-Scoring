# SDQ-Scoring in R
## Scoring the Strengths &amp; Difficulties Questionnaire for age 4-17 or 18+
Read **SDQ_English(UK)_4-17scoring.pdf** (stpn.uk, 2016) in the repository for detailed instructions on administering and scoring the questionnaire (see note below)

The scoring algorithm is based on the 25 variables plus impact items for each questionnaire. The variable names are as follows:</br>

consid	=	Item 1 : considerate</br>
restles	=	Item 2 : restless</br>
somatic	=	Item 3 : somatic symptoms</br>
shares	=	Item 4 : shares readily</br>
tantrum	=	Item 5 : tempers</br>
loner	=	Item 6 : solitary</br>
obeys	=	Item 7 : obedient</br>
worries	=	Item 8 : worries</br>
caring	=	Item 9 : helpful if someone hurt</br>
fidgety	=	Item 10 : fidgety</br>
friend	=	Item 11 : has good friend</br>
fights	=	Item 12 : fights or bullies</br>
unhappy	=	Item 13 : unhappy</br>
popular	=	Item 14 : generally liked</br>
distrac	=	Item 15 : easily distracted</br>
clingy	=	Item 16 : nervous in new situations</br>
kind	=	Item 17 : kind to younger children</br>
lies	=	Item 18 : lies or cheats [for the SDQ for 2-4 year olds, replace 'lies' with 'argues']</br>
bullied	=	Item 19 : picked on or bullied</br>
helpout	=	Item 20 : often volunteers</br>
reflect	=	Item 21 : thinks before acting</br>
steals	=	Item 22 : steals [for the SDQ for 2-4 year olds, replace 'steals' with 'spite']</br>
oldbest	=	Item 23 : better with adults than with children</br>
afraid	=	Item 24 : many fears</br>
attends	=	Item 25 : good attention</br>

### For each of these items, the score is as follows:</br>
- Not true = 0
- Somewhat true = 1
- Certainly true = 2

### For each informant, the code generates five scores:</br>

- emotion	=	emotional symptoms</br>
- conduct	=	conduct problems</br>
- hyper	=	hyperactivity/inattention</br>
- peer	=	peer problems</br>
- prosoc	=	prosocial
- ebdtot	=	total difficulties

Note: Impact questions and **impact scores are not included** in this R script. Thus, the code serves to calculate the six SDQ scores listed above, and **not the impact scores**.<br/>
Syntax assumes data is already read into R

