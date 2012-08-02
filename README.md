<!-- markdown syntax -->

# Reinforcement learning #
The scripts in here parse log files generated from the Replicator robots. The log files currently contain only infrared sensors, the camera - regretfully - ceased to work properly. By manually moving away the robots from the perfect position (hence the name "reverse reinforce") we can learn a preferential order of observations. We do not need to manually indicate which observation is preferred above which other observation, because by moving away from our target position, the observations are automatically ordered by reverse preference (give or take noise induced by shaking hands). By using a [rank SVM (Support Vector Machine)](http://www.cs.cornell.edu/people/tj/svm_light/svm_rank.html) the preference of a given observation can be learned. The rank SVM does not care about absolute differences in preferences, so multiple runs can be used, because the preference values are not compared across runs (with in one run having the robot moving much slower than in the other run for example).

## Installation ##
Install [svm_light](http://www.cs.cornell.edu/people/tj/svm_light/svm_rank.html) and run the scripts in a BASH shell.

## Results ##
Results are currently not yet in the form of a controller, because the prototype Replicator robots failed to move. It is namely the case that the power board provides multiple voltage levels for different purposes. To move the screw drive a higher voltage is needed than to turn on the laser (3.3V) for example. Due to a glitch in the hardware for the power board it has been possible for us to get sensor data from the infrared sensors, but not to drive the robots around.

The results are in the form of a picture in which we show that the preferences between observations are learned indeed. The outcome of the rank SVM should be monotonically decreasing, just as our actual preferences. As indicated before, only relative preferences are important to - in the end - have the robot move towards observations with a higher preference. Hence, the lines in this figure do not need to have a minimum standard error, only the feature of having it monotonically decreasing is important.

![Prediction comparison](https://github.com/mrquincle/reverse_reinforce/raw/master/run0/prediction_comparison.png "Prediction comparison")

For people that are into reinforcement learning: we now obtained the value function (which assigns a reward/cost to each state). However, we also need a controller. A controller can follow a greedy policy picking the best action at every state. However, to do this it needs a model of the environment: it needs to know in which state it will end up after executing a certain action. To build a controller a delayed transition model can be used in case of only a few actions (left, right, ahead) and a camera (see second paper below). It returns a new state (in this case an observation matrix, a shifted image) given an old state and an action. The cost of this shifted observation can be obtained through the value function.

The problem with infared sensors is that the shift in the observation vector when going to the right or left is not known beforehand. Different from images it is hard to come up with something that says, ah it is gonna shift k pixels when I perform action X.

## Acknowledgments
All original ideas and concepts on how to solve the docking problem between two robots come from Michele Sebag and her colleagues from the machine learning group at INRIA / University of Paris.

## Where can I read more?
In much more detail than I can afford myself here, the concepts are described in the following two papers, especially the second which is about a robot following another robot. The main concept there is to use Murphy's law to someone's advantage: when a robot is following another robot it will perform worse and worse over time. Hence, its state can be described as being in reverse preferential order.

* Preference-based Policy Learning (Riad Akrour, Marc Schoenauer, and Michele Sebag) [(pdf)](http://hal.inria.fr/docs/00/62/50/01/PDF/Preference-based_Policy_Learning.pdf)
* Direct Value Learning: a Preference-based Approach to Reinforcement Learning (David Meunier, Yutaka Deguchi, Riad Akrour, Einoshin Suzuki, Marc Schoenauer, Michele Sebag) [(pdf)](http://www.ke.tu-darmstadt.de/events/PL-12/papers/06-sebag.pdf)

## Copyrights
The copyrights (2012) belong to:

- Author: Anne van Rossum
- Almende B.V., http://www.almende.com and DO bots B.V., http://www.dobots.nl
- Rotterdam, The Netherlands
