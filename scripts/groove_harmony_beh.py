# -*- coding: utf-8 -*-
"""
Groove Harmony behavioral ratings

Script to present stimuli and record participants' ratings
currently optimized for behavioral test in the scanner 

Experiment where participants listen to a musical 
pattern then rate how much they wanted to move, how much pleasure they experienced
and how strong the beat was using key presses (1-5). 

RUNS FROM PSYCHOPY STANDALONE APP (v2021.2.3). NOT TESTED OUTSIDE STANDALONE APP.
**********************
Stimuli (built by Tomas Matthews / Sander Celma / Ole Heggli)
***********************
Stimuli consist of musical patterns lasting 10 seconds that vary rhythm 
and harmonic complexity
    4 levels of rhythmic complexity: isochronous, low, medium, high
    2 levels of harmonic complexity: medium, high
    8 conditions: IM, IH, LM, LH, MM,MH,HM,HH

**************************
Experimental design
*************************
-factorial design: 4(rhythmic complexity) X 2(harmonic complexity)
-trials divided in 6 blocks per participant
-trials randomized for each subject
-each unique stimulus is presented 3 times
-the order of the three questions is counterbalanced across stimulus instances
"""

"""
'IMPORT'
"""
from psychopy import prefs
prefs.hardware['audioLib'] = ['PTB']
from psychopy import visual, core, sound, event, gui, logging#, parallel
import numpy as np
import random as rnd
import os
import csv
# Uncomment only if MEG in Aarhus:
from triggers import setParallelData # only if
setParallelData(0)

my_path = os.path.abspath(os.path.dirname(__file__))
os.chdir(my_path)
os.chdir('..')

# Load stimulus list and store in a dictionary
# change the stim file below to use different stimuli 
stim_file = open('stimuli/stim_list_beh.csv',newline = '') 
stim_obj = csv.DictReader(stim_file,delimiter = ',')
blocks = {}

for row in stim_obj:
    blocks.setdefault(row['block'],{})
    for column, value in row.items():  # consider .iteritems() for Python 2
        blocks[row['block']].setdefault(column, []).append(value)

# get block names
bnames = [b for b in blocks if b != 'practice']

# collect soundfile names:
all_stims = []
for b in blocks:
    all_stims = all_stims + blocks[b]['number']

# load sounds
sounds = {s: sound.Sound('stimuli/{0:0>2}.wav'.format(int(s))) 
            for s in np.unique(all_stims)}

# randomize trial order
for b in blocks:
        blocks[b]['order'] = np.arange(len(blocks[b]['code']))
        if b != 'practice':
            rnd.shuffle(blocks[b]['order'])

#function and key to quit the experiment and save log file
def quit_and_save():
    win.close()
    if logfile:
       logfile.close()
    logging.flush()
    core.quit()
    
event.globalKeys.add(key='escape', func=quit_and_save, name='shutdown')

#response keys
resp_keys = ['1','2','3','4','5','escape']

# Collect participant identity and options:
ID_box = gui.Dlg(title = 'Subject identity')
ID_box.addField('ID: ')
ID_box.addField('practice? (YES: 1, higher or blank; NO: 0): ')
sub_id = ID_box.show()

# create switch to do practice block or not
practice_switch = 1
if sub_id[1] == '0':
    practice_switch = 0

# create display window and corresponding texts
txt_color = 'white'
win = visual.Window(fullscr=True, color='black')

# set frame rate
frate = np.round(win.getActualFrameRate())
prd = 1000 / frate
print('screen fps = {} - cycle duration = {} ms'.format(frate,  np.round(prd,2)))

# create all the text to be displayed
fixation = visual.TextStim(win, text='+', color=txt_color, height=0.2)
instructions =  visual.TextStim(win, 
                text = 'You will hear various short musical patterns.\n'
                'After each one, you will be asked three questions in random order:\n\n\n'
                'a. The degree to which the musical pattern made you WANT TO MOVE\n\n'
                'b. How much PLEASURE you experienced from the musical pattern\n\n'
                'c. How strong the BEAT was in the musical pattern \n\n\n'
                'To answer, please type 1, 2, 3, 4 or 5 on your keyboard, as follows:\n\n'
                'not at all / none / very weak < 1 2 3 4 5 >  very much / a lot / very strong\n\n'
                'Press spacebar to continue.',
                color=txt_color, wrapWidth=2)

rating_txt = {}
rating_txt['p'] = ('How much pleasure did you experience listening to this musical pattern?\n\n'
                   'none  < 1    2    3    4    5 >  a lot')

rating_txt['w'] = ('How much did this musical pattern make you want to move?\n\n'
                    'not at all  < 1    2    3    4    5 >  very much')
                

rating_txt['b'] = ('How strong was the beat in the musical pattern?\n\n'
                    'very weak  < 1    2    3    4    5 >  very strong')

practice = visual.TextStim(win, 
                text = 'First, let us do some practice trials.\n\n'
                    'When ready, press spacebar to hear the first musical pattern.',
                color=txt_color, wrapWidth=1.8)

main_task = visual.TextStim(win,
                text = 'This is the end of the practice trials.\n\n'
                    'When ready, press spacebar to start the main task.',
                color=txt_color, wrapWidth=1.8)

break_txt = visual.TextStim(win,
                text = 'Now it is time for a little break.\n'
                        'Take as much time as you need.\n\n'
                        'Press spacebar when ready to continue.',
                color=txt_color, wrapWidth=1.8)

block_end_txt = visual.TextStim(win, 
                text = 'This is the end of the first block.\n\n'
                        'Now take a little break and press space when ready to continue',
                color=txt_color, wrapWidth=1.8)

end_txt = visual.TextStim(win, 
                text = 'This is the end of the experiment.\n'
                       'Thanks for participating!',
                color=txt_color, wrapWidth=1.8)

trialtxt = visual.TextStim(win, text='',color=txt_color, height=0.1)
rating_win = visual.TextStim(win, text='',color=txt_color, wrapWidth=1.8)

#set clocks
RT = core.Clock()
exp_time = core.Clock()

# set default log file
logging.setDefaultClock(exp_time)
log_fn_def = 'logs/' + sub_id[0] +  '_default_beh.log'
lastLog = logging.LogFile(log_fn_def, level=logging.INFO, filemode='a')

# set custom log file
log_fn_cus = 'logs/' + sub_id[0] +  '_custom_beh.csv'
logfile = open(log_fn_cus,'w')
logfile.write("subject,trialCode,code,number,name,rhythm,harmony,"
              "condition,block,startTime,wantingToMove,pleasure,beatStrength,wrt,prt,brt\n")

# make function to loop over trials and present the stimuli
def block_run(s_dict, s_order, b_sounds, breaks=[]):
    """
    s_dict: dictionary containing the stimulus list and metadata, as loaded 
            from a csv file. Must contain the lists:

                'trial_code': code of the trial before randomization
                'code': experiment specific stimulus code
                'name': stimulus name
                'number': stimulus number corresponding to wav file
                'rhythm': rhythm complexity (iso,low,medium,high)
                'harmony': harmony complexity (medium, high)
                'condition': 'order of the questions w,p,b'
                'block': 'practice' or 'main'

            each list contains the above information for each trial in the
            experiment.

    s_order: randomized stimulus order. Must match the length of s_dict lists.
    b_sounds: dictionary with the loaded sounds. Keys must match elements in the
            "number" list in s_dict.
    breaks: list with numbers indicating the indices of trials where a pause is
            wanted.
    """
    for mtrial, midx in enumerate(s_order): # loop over trials
        m = s_dict['number'][midx]
        trialtxt.setText('trial {} / {}'.format(mtrial + 1, len(s_order)))
        trialtxt.draw()
        win.flip()
        core.wait(1)
        fixation.draw()
        win.flip()
        core.wait(1)
        nextFlip = win.getFutureFlipTime(clock='ptb')
        startTime = win.getFutureFlipTime(clock=exp_time)
        trigger = int(s_dict['trigger'][midx])
        win.callOnFlip(setParallelData, int(trigger)) # only if MEG in Aarhus
        #win.callOnFlip(print, trigger)
        b_sounds[m].play(when = nextFlip)
        
        # we synchronize stimulus delivery with screen frames for time acc.
        for frs in range(int(np.round(5000/prd))): # wait 10 seconds
            fixation.draw()
            win.flip()
        resp, rt = {}, {}
        for q in s_dict['condition'][midx]:
            event.clearEvents(eventType=None) #'keyboard')
            RT.reset()
            resp[q] = None
            while resp[q] == None:
                rating_win.setText(rating_txt[q])
                rating_win.draw()
                win.flip()
                key = event.getKeys(timeStamped = RT, keyList = resp_keys)
                #search for key presses.
                if len(key) > 0:
                    resp[q] = key[0][0]
                    rt[q] = key[0][1]

            # If you want to put a time limit on the response, uncomment:
            #elif RT.getTime() > 12: #17 after trial onset
            #    resp = 0
            #    rt = RT.getTime()

        lrow = '{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}\n'
        lrow = lrow.format(sub_id[0],s_dict['trial_code'][midx],s_dict['code'][midx],
                            m,s_dict['name'][midx],s_dict['rhythm'][midx],
                            s_dict['harmony'][midx],s_dict['condition'][midx],
                            s_dict['block'][midx],startTime,resp['w'],resp['p'],
                            resp['b'],rt['w'],rt['p'],rt['b'])
        logfile.write(lrow)
        if mtrial in breaks:
            break_txt.draw()
            win.flip()
            event.waitKeys()
 
# Now run the experiment.
# present instructions
instructions.draw()
win.flip()
event.waitKeys()

for bidx,b in enumerate(bnames):
    
    # run practice trials if requested
    if practice_switch == 1:
        practice.draw()
        win.flip()
        event.waitKeys()

        block_run(blocks['practice'], blocks['practice']['order'], sounds)

        main_task.draw()
        win.flip()
        event.waitKeys()

    #run main task
    block_run(blocks[b],blocks[b]['order'], sounds, breaks = [23])
    
    if  (bidx + 1) < len(bnames):
        block_end_txt.draw()
        win.flip()
        event.waitKeys()

end_txt.draw()
win.flip()
core.wait(2)

