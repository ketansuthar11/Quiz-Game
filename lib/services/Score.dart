class Score{
  static int correctAns=0;
  int options(List<int?> selectedOptions, List quiz){
    int score=0;
    for(int i=0;i<quiz.length;i++){
      for(int j=0;j<4;j++){
        bool option = quiz[i]['options'][j]['is_correct'];
        if(option==true &&j==selectedOptions[i]){
          score+=4;
        }
        else if(option==true &&j!=selectedOptions[i] && selectedOptions[i]!=null){
          score-=1;
        }
      }
    }
    return score;
  }

  int correctAnswers(List<int?> selectedOptions, List quiz){
    int count=0;
    for(int i=0;i<quiz.length;i++){
      for(int j=0;j<4;j++){
        bool option = quiz[i]['options'][j]['is_correct'];
        if(option==true &&j==selectedOptions[i]){
          count+=1;
        }
      }
    }
    correctAns=count;
    return count;
  }

  int answered(List<int?> selectedOptions){
    int count=0;
    for(int i=0;i<selectedOptions.length;i++){
      if(selectedOptions[i]!=null){
        count++;
      }
    }
    return count;
  }
}