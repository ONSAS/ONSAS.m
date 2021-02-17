
close all, clear all %#ok
keyword = '_test' ;

if isunix, dirSep = '/'; else dirSep = '\'; end
addpath( [ pwd  dirSep '..' dirSep  'src' dirSep ] ); octaveBoolean = isThisOctave ;

if octaveBoolean
  fileslist = readdir('../examples/');
else
  auxMatlab = dir('../examples')                  ;
  fileslist = cell(length( auxMatlab ),1) ;
  for k=1:length( auxMatlab )
    fileslist{k} = auxMatlab(k).name ;
  end
end

keyfiles = cell(length(fileslist),1); totalRuns = 0  ;

for i=1:length(fileslist)
  if length(fileslist{i})>5,
    lastFiveChars = fileslist{i}; lastFiveChars = lastFiveChars((end-4:end)) ;
    if strcmp( lastFiveChars, keyword )
      totalRuns             = totalRuns +1 ;
      keyfiles{ totalRuns } = fileslist{i} ;
    end
  end
end

current  = 1 ;   verifBoolean = 1 ;  testDir = pwd ;

while current <= totalRuns && verifBoolean == 1

  % run current example
  fprintf([' === running script: ' keyfiles{current} '\n' ]);
  
  %~ run( [ pwd dirSep '..' dirSep 'examples' dirSep keyfiles{current} dirSep 'onsasExample_' keyfiles{current} '.m' ] ) ;

  cd( [ pwd dirSep '..' dirSep 'examples' dirSep keyfiles{current} dirSep ] )

  % save key files data to avoid clear all commands
  save( '-mat', 'exData.mat', 'current', 'totalRuns', 'keyfiles', 'dirSep', 'testDir' );

  run( [ 'onsasExample_' keyfiles{current} '.m' ] ) ;
  
  if verifBoolean
    fprintf([' === test ' problemName ' problem:  PASSED === \n\n']);
  else
    fprintf([' === test ' problemName ' problem FAILED   === \n\n']);
  end
  
  % reload key files data and increment current
  load('exData.mat') ;  current = current + 1 ; delete('exData.mat');
  cd ( testDir )
end

if verifBoolean ==1
  fprintf('test PASSED!\n')
else
  error('test examples not passed.')
  
end