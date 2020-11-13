%% SIMULATION TOURBILLONS
%Il faut enregistrer tous les fichiers d'une simu dans folder dans le même
%dossier où se trouve ce fichier matlab
%Il faut nommer les fichier ReXXX ou XXX est le nombre de reynolds
% ex: Re020 = nb de reynolds de 20, Re250 = nb de reynolds de 250

exp_name = rdir('Re*');
exp_name = sort(exp_name(1,:));
nb_exp = length(exp_name);


%% retrieve data
reynolds = zeros(1,nb_exp); %initialisation liste contenant tout les Re

for i = 1:nb_exp
   reynolds_name = exp_name{i}; % -> 'ReXX' (str)
   reynolds_num = str2double(extractAfter(reynolds_name, 2)); % -> XX (double)
   reynolds(i) = reynolds_num; %liste contenant tous les Re
   
   % data(:,1) = numero de l'itération
   % data(:,2) = composante de trainée (coeff de trainée adimensionnel)
   % data(:,3) = composante de portance (coeff de portance adimensionnel)
   data.(reynolds_name) = load(strcat(reynolds_name,'/f_vs_t_b10_re',num2str(reynolds_num),'.txt'));
   
   %convertir iteration en temps adimensionnel
   data.(reynolds_name)(:,1) = data.(reynolds_name)(:,1)*0.1;

end


%% plot coefficient de trainée en fonction du temps pour différents nombres de reynolds

figure('Name', 'coefficient de trainée en fonction du temps pour différents reynolds', 'NumberTitle', 'off')
for i = 1:nb_exp
   reynolds_name = exp_name{i};
   
   l = length(data.(reynolds_name)(:,1)); %longueur de l'exp
   threshold = 1000; %nombre d'iteractions max que l'on veut
   plage = 1:l; %plage des valeurs
   if l > threshold
       plage = 1:threshold; %crop
   end
   
   hold on
   plot(data.(reynolds_name)(plage,1),data.(reynolds_name)(plage,2))
   legend(exp_name, 'Interpreter', 'none')
   xlabel('temps (adimensionnel)')
   ylabel('coefficient de trainée (adimensionnel)')
   title('coefficient de trainée en fonction du temps pour différents reynolds')
   
end

%%  plot coefficient de trainée moyen en fonction de reynolds

figure('Name', 'coefficient de trainée en fonction du nombre de reynolds', 'NumberTitle', 'off')
coeff_trainee = zeros(1,nb_exp); % initialisation des coeffecients de trainée

for i = 1:nb_exp
    reynolds_name = exp_name{i};
    
    window_max = length(data.(reynolds_name)(:,1)); %longueur de l'exp
    window_min = floor(window_max/2);
    avg_window = window_min:window_max; %plage sur laquelle on moyenne le coeff de trainée
    
    coeff_trainee_avg = mean(data.(reynolds_name)(avg_window,2)); %on moyenne sur le regime permanent
    coeff_trainee(i) = coeff_trainee_avg;
end

loglog(reynolds, coeff_trainee, '-')
grid on
xlabel('nombre de reynolds')
ylabel('coefficient de trainée (adimensionnel)')
title('coefficient de trainée en fonction du nombre de reynolds')

%% plot coefficient de portance en fonction du temps pour différents nombres de reynolds

figure('Name', 'coefficient de portance en fonction du temps pour différents reynolds', 'NumberTitle', 'off')
for i = 1:7
   reynolds_name = exp_name{i};
   
   l = length(data.(reynolds_name)(:,1)); %longueur de l'exp
   threshold = 1200; %nombre d'iteractions max que l'on veut
   plage = 1:l; %plage des valeurs
   if l > threshold
       plage = 1:threshold; %crop
   end
   
   hold on
   plot(data.(reynolds_name)(plage,1),data.(reynolds_name)(plage,3))
   legend(exp_name, 'Interpreter', 'none')
   xlabel('temps (adimensionnel)')
   ylabel('coefficient de portance (adimensionnel)')
   title('coefficient de portance en fonction du temps pour différents reynolds')
   
end

%% plot coefficient de portance moyen en fonction de reynolds
% enter critical reynolds number 
Rec = 34.2 

figure('Name', 'coefficient de portance moyen en fonction du nombre de reynolds', 'NumberTitle', 'off')
coeff_portance = zeros(1,nb_exp); % initialisation des coeffecients de trainée

for i = 1:nb_exp
    reynolds_name = exp_name{i};
    
    amplitude = max(abs(data.(reynolds_name)(:,3)))*2; %calcul l'amplitude du signal
    coeff_portance(i) = amplitude;
end

re_rec = (reynolds-Rec);
plot(re_rec,coeff_portance, 'o')
grid on
xlabel('ecart au seuil Re-Re_c')
ylabel('coefficient de portance (adimensionnel)')
title('coefficient de portance en fonction du nombre de reynolds')


%% fft du coefficient de portance
figure('Name', 'coefficient de portance en fonction du temps pour différents reynolds', 'NumberTitle', 'off')

freq = 10; %freq d'echantillonnage
T = 1/freq; % periode d'echantillonage

fe_tourbillon = zeros(nb_exp,2);

for i = 1:nb_exp
   reynolds_name = exp_name{i};
   reynolds_num = str2double(extractAfter(reynolds_name, 2));
   
   portance_fft = fft(data.(reynolds_name)(:,3)); % FFT de la portance
   l = length(data.(reynolds_name)(:,1)); %longueur de l'exp
   
   P2 = abs(portance_fft/l); %compute 2 sided spectrum
   P1 = P2(1:l/2+1); %get 1 side
   P1(2:end-1) = 2*P1(2:end-1); %single sided spectrum, even valued signal 
   
   f = freq*(0:(l/2))/l; %plage des frequences (adimensionnée)
   plage = 1:length(f)/10; %view window
   
   hold on
   plot(f(plage),P1(plage))
   legend(exp_name, 'Interpreter', 'none')
   xlabel('frequence (adimensionnelle)')
   ylabel('TF(portance) (adimensionnelle)')
   title('TF de la portance')
   
   [~,fe_idx] = max(P1);
   fe_tourbillon(i,:) = [reynolds_num f(fe_idx)];
   
end

%% mesure de la frequence d'emission des tourbillons a partir de la periodicité de la portance

figure('Name', "fréquence d'emission des tourbillons en fonction du nombre de Reynolds", 'NumberTitle', 'off')
plot(fe_tourbillon(:,1), fe_tourbillon(:,2),'o')
xlabel('nombre de Reynolds')
ylabel('fréquence des troubillons')
title("fréquence d'emission des tourbillons en fonction du nombre de Reynolds")
grid on
axis([0 600 -0.05 0.3])

mean(fe_tourbillon(7:end,2))

%% enveloppe de la portance a faible Re
figure('Name', "coefficient de portance en fonction du temps, Re faible", 'NumberTitle', 'off')

for i = 1:6
   reynolds_name = exp_name{i};
   
   %plot low Re portance constant
   start = 50;
   temps = data.(reynolds_name)(start:end,1);
   portance = data.(reynolds_name)(start:end,3);
   plot(temps,portance,'DisplayName',reynolds_name)
   legend('-DynamicLegend')
   %determinaion de l'enveloppe
   [y_upper, y_lower] = envelope(portance,20,'peak');
   
   hold on
   y_up = plot(temps,y_upper,'-'); %plot upper envelope 
   y_low = plot(temps,y_lower,':'); %plot lower envelope
   y_up.Annotation.LegendInformation.IconDisplayStyle = 'off';
   y_low.Annotation.LegendInformation.IconDisplayStyle = 'off';
   
   xlabel('temps (adimensionnel)')
   ylabel('coefficient de portance (adimensionnel)')
   title('coefficient de portance en fonction du temps pour Re<=35')
   
   
   enveloppe.(reynolds_name) = [temps y_upper y_lower];
end
%% fit
%changer i a chaque itération et appeler la commande cftool dans le terminal en prenant X
%et Y comme variables dans le menu

for i = 3
    reynolds_name = exp_name{i};
    start = 200;
    finish = 800;
    env = enveloppe.(reynolds_name);
    X = env(start:finish,1);
    Y = (env(start:finish,2) - mean(data.(reynolds_name)(start:end,3)))/max(env(:,2));
    plot(X,Y)
  
end
%% mesure du taux de croissance d'instabilité
%il faut tout rentrer a la main dans les listes
figure('Name', "taux d'accroissement en fonction de Re", 'NumberTitle', 'off')

Re = [ 30 33 34 35 38 40 45];
sigma = [-0.03602 -0.007493 0.001089 0.009192 0.02725 0.04346 0.06892];
sigma_error = [[-0.03604 -0.036]; [-0.007498 -0.007487]; [0.001099 0.001089]; [0.009191 0.009193]; [0.02717 0.02733]; [0.04329 0.04364];[0.06863 0.0692]];
sigma_error = sigma_error - [sigma' sigma'];
errorbar(Re,sigma,sigma_error(:,1), sigma_error(:,2),'o');
axis([28 50 -0.05 0.08])
xlabel('nombre de reynolds Re')
ylabel("taux d'accroissement exponentiel sigma (1/s)")
title("taux d'accroissement en fonction de Re")
