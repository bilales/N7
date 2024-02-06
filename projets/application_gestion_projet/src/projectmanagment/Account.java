/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package projectmanagment;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.border.EmptyBorder;
import javax.swing.plaf.basic.BasicButtonUI;

import projectmanagment.Home;
import projectmanagment.Login;
import projectmanagment.Project;

/**
 *
 * @author khadija
 */
public class Account extends javax.swing.JFrame {
    private int mouseX, mouseY;
    /**
     * Creates new form Account
     */
    public Account() {
        initComponents();
        
        minimize.setBorder(new EmptyBorder(0, 0, 0, 0));
        exit.setBorder(new EmptyBorder(0, 0, 0, 0));
        minimize.setUI(new BasicButtonUI());
        minimize.setCursor(new Cursor(Cursor.HAND_CURSOR));
        minimize.setBackground(Color.white);
        minimize.addMouseListener( new MouseListener(){
            @Override
            public void mouseClicked(MouseEvent e) {
            }

            @Override
            public void mousePressed(MouseEvent e) {
            }

            @Override
            public void mouseReleased(MouseEvent e) {
            }

            @Override
            public void mouseEntered(MouseEvent e) {
                minimize.setForeground((new Color(40, 47, 57)));
            }

            @Override
            public void mouseExited(MouseEvent e) {
                minimize.setForeground((new Color(87, 78, 213)));
            }

        }
        );
        
        account.setBackground(new Color(97, 96, 97));
        account.setCursor(new Cursor(Cursor.HAND_CURSOR));
        account.setUI(new BasicButtonUI());
        JButton[] btns = {signOut, overview, projects};
        for(JButton btn : btns){
            btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
            btn.setUI(new BasicButtonUI());
            btn.addMouseListener( new MouseListener(){
                    @Override
                    public void mouseClicked(MouseEvent e) {
                    }

                    @Override
                    public void mousePressed(MouseEvent e) {
                    }

                    @Override
                    public void mouseReleased(MouseEvent e) {
                    }

                    @Override
                    public void mouseEntered(MouseEvent e) {
                        btn.setBackground(new Color(97, 96, 97));
                    }

                    @Override
                    public void mouseExited(MouseEvent e) {
                        btn.setBackground(new Color(88, 101, 242));
                    }

                }

                );
        }
        
        modifier.setUI(new BasicButtonUI());
        modifier.setCursor(new Cursor(Cursor.HAND_CURSOR));
        modifier.addMouseListener( new MouseListener(){
            @Override
            public void mouseClicked(MouseEvent e) {
            }

            @Override
            public void mousePressed(MouseEvent e) {
            }

            @Override
            public void mouseReleased(MouseEvent e) {
            }

            @Override
            public void mouseEntered(MouseEvent e) {
                modifier.setBackground(new Color(88, 101, 242));
            }

            @Override
            public void mouseExited(MouseEvent e) {
                modifier.setBackground(new Color(218,215,215));
            }

        }
        );
        
        exit.setUI(new BasicButtonUI());
        exit.setCursor(new Cursor(Cursor.HAND_CURSOR));
        exit.addMouseListener( new MouseListener(){
            @Override
            public void mouseClicked(MouseEvent e) {
            }

            @Override
            public void mousePressed(MouseEvent e) {
            }

            @Override
            public void mouseReleased(MouseEvent e) {
            }

            @Override
            public void mouseEntered(MouseEvent e) {
                exit.setForeground(new Color(97, 96, 97));
                exit.setIcon(new ImageIcon(getClass().getResource("/icons/logout_gray.png")));
            }

            @Override
            public void mouseExited(MouseEvent e) {
                exit.setForeground(Color.WHITE);
                exit.setIcon(new ImageIcon(getClass().getResource("/icons/logout_white.png")));
            }

        }
        );
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        rootAccount = new javax.swing.JPanel();
        header = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jPanel9 = new javax.swing.JPanel();
        minimize = new javax.swing.JButton();
        jTextField1 = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        bodyAccount = new projectmanagment.RoundPanel();
        emailAccount = new javax.swing.JTextField();
        jLabelEmail = new javax.swing.JLabel();
        fNameAccount = new javax.swing.JTextField();
        jLabelFname = new javax.swing.JLabel();
        countryAccount = new javax.swing.JTextField();
        jLabelCountry = new javax.swing.JLabel();
        jLabelPass = new javax.swing.JLabel();
        passAccount = new javax.swing.JTextField();
        modifier = new javax.swing.JButton();
        menuBar = new javax.swing.JPanel();
        jLabel12 = new javax.swing.JLabel();
        exit = new javax.swing.JButton();
        overview = new javax.swing.JButton();
        projects = new javax.swing.JButton();
        account = new javax.swing.JButton();
        signOut = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setLocationByPlatform(true);
        setUndecorated(true);

        rootAccount.setBackground(new java.awt.Color(255, 255, 255));
        rootAccount.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 0, 1, 1, new java.awt.Color(88, 101, 242)));

        header.setBackground(new java.awt.Color(255, 255, 255));
        header.setPreferredSize(new java.awt.Dimension(920, 60));

        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_search_20px.png"))); // NOI18N

        jPanel9.setOpaque(false);
        jPanel9.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                jPanel9MouseDragged(evt);
            }
        });
        jPanel9.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jPanel9MousePressed(evt);
            }
        });
        jPanel9.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        minimize.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        minimize.setForeground(new java.awt.Color(87, 78, 213));
        minimize.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_subtract_15px_1.png"))); // NOI18N
        minimize.setBorder(null);
        minimize.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        minimize.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        minimize.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                minimizeMouseClicked(evt);
            }
        });
        jPanel9.add(minimize, new org.netbeans.lib.awtextra.AbsoluteConstraints(850, 2, 20, 20));

        jTextField1.setForeground(new java.awt.Color(204, 204, 204));
        jTextField1.setText("Search");
        jTextField1.setBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, new java.awt.Color(153, 153, 153)));
        jTextField1.setPreferredSize(new java.awt.Dimension(64, 35));

        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_male_user_30px_2.png"))); // NOI18N

        javax.swing.GroupLayout headerLayout = new javax.swing.GroupLayout(header);
        header.setLayout(headerLayout);
        headerLayout.setHorizontalGroup(
            headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(headerLayout.createSequentialGroup()
                .addGap(25, 25, 25)
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 338, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(416, 416, 416)
                .addComponent(jLabel3)
                .addGap(0, 0, Short.MAX_VALUE))
            .addComponent(jPanel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        headerLayout.setVerticalGroup(
            headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(headerLayout.createSequentialGroup()
                .addGroup(headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(headerLayout.createSequentialGroup()
                        .addComponent(jPanel9, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, 0)
                        .addGroup(headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.CENTER)
                            .addComponent(jLabel2)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(headerLayout.createSequentialGroup()
                        .addGap(26, 26, 26)
                        .addComponent(jLabel3)))
                .addContainerGap(18, Short.MAX_VALUE))
        );

        emailAccount.setBackground(new java.awt.Color(244, 244, 244));
        emailAccount.setBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, new java.awt.Color(0, 0, 0)));
        emailAccount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                emailAccountActionPerformed(evt);
            }
        });

        jLabelEmail.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        jLabelEmail.setText("Email");

        fNameAccount.setBackground(new java.awt.Color(244, 244, 244));
        fNameAccount.setBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, new java.awt.Color(0, 0, 0)));
        fNameAccount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                fNameAccountActionPerformed(evt);
            }
        });

        jLabelFname.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        jLabelFname.setText("Full Name");

        countryAccount.setBackground(new java.awt.Color(244, 244, 244));
        countryAccount.setBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, new java.awt.Color(0, 0, 0)));
        countryAccount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                countryAccountActionPerformed(evt);
            }
        });

        jLabelCountry.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        jLabelCountry.setText("Country");

        jLabelPass.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        jLabelPass.setText("Password");

        passAccount.setBackground(new java.awt.Color(244, 244, 244));
        passAccount.setBorder(javax.swing.BorderFactory.createMatteBorder(0, 0, 1, 0, new java.awt.Color(0, 0, 0)));
        passAccount.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                passAccountActionPerformed(evt);
            }
        });

        modifier.setBackground(new java.awt.Color(218, 215, 215));
        modifier.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        modifier.setText("Edit");
        modifier.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        modifier.setPreferredSize(new java.awt.Dimension(65, 22));
        modifier.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                modifierMouseClicked(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                modifierMousePressed(evt);
            }
        });
        modifier.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                modifierActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout bodyAccountLayout = new javax.swing.GroupLayout(bodyAccount);
        bodyAccount.setLayout(bodyAccountLayout);
        bodyAccountLayout.setHorizontalGroup(
            bodyAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(bodyAccountLayout.createSequentialGroup()
                .addGap(43, 43, 43)
                .addGroup(bodyAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelEmail)
                    .addComponent(emailAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 247, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelFname)
                    .addComponent(fNameAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 247, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 74, Short.MAX_VALUE)
                .addGroup(bodyAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(modifier, javax.swing.GroupLayout.PREFERRED_SIZE, 247, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelCountry)
                    .addComponent(countryAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 247, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabelPass)
                    .addComponent(passAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 247, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(163, 163, 163))
        );
        bodyAccountLayout.setVerticalGroup(
            bodyAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(bodyAccountLayout.createSequentialGroup()
                .addGap(90, 90, 90)
                .addGroup(bodyAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(bodyAccountLayout.createSequentialGroup()
                        .addGroup(bodyAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(bodyAccountLayout.createSequentialGroup()
                                .addComponent(jLabelEmail)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(emailAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(bodyAccountLayout.createSequentialGroup()
                                .addComponent(jLabelCountry)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(countryAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(38, 38, 38)
                        .addComponent(jLabelFname)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(fNameAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(bodyAccountLayout.createSequentialGroup()
                        .addComponent(jLabelPass)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(passAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 88, Short.MAX_VALUE)
                .addComponent(modifier, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(136, 136, 136))
        );

        menuBar.setBackground(new java.awt.Color(88, 101, 242));
        menuBar.setPreferredSize(new java.awt.Dimension(240, 680));

        jLabel12.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel12.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_team_builder_90px_1.png"))); // NOI18N

        exit.setBackground(new java.awt.Color(87, 100, 241));
        exit.setFont(new java.awt.Font("SansSerif", 1, 14)); // NOI18N
        exit.setForeground(new java.awt.Color(255, 255, 255));
        exit.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/logout_white.png"))); // NOI18N
        exit.setText("Exite");
        exit.setBorder(null);
        exit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitActionPerformed(evt);
            }
        });

        overview.setBackground(new java.awt.Color(88, 101, 242));
        overview.setFont(new java.awt.Font("SansSerif", 1, 18)); // NOI18N
        overview.setForeground(new java.awt.Color(255, 255, 255));
        overview.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_overview_30px_9.png"))); // NOI18N
        overview.setText("Overview");
        overview.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 20, 1, 1));
        overview.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        overview.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        overview.setIconTextGap(15);
        overview.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                overviewActionPerformed(evt);
            }
        });

        projects.setBackground(new java.awt.Color(88, 101, 242));
        projects.setFont(new java.awt.Font("SansSerif", 1, 18)); // NOI18N
        projects.setForeground(new java.awt.Color(255, 255, 255));
        projects.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_project_30px.png"))); // NOI18N
        projects.setText("Projects");
        projects.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 20, 1, 1));
        projects.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        projects.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        projects.setIconTextGap(15);
        projects.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                projectsActionPerformed(evt);
            }
        });

        account.setBackground(new java.awt.Color(88, 101, 242));
        account.setFont(new java.awt.Font("SansSerif", 1, 18)); // NOI18N
        account.setForeground(new java.awt.Color(255, 255, 255));
        account.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_search_account_30px.png"))); // NOI18N
        account.setText("Account");
        account.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 20, 1, 1));
        account.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        account.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        account.setIconTextGap(15);
        account.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                accountActionPerformed(evt);
            }
        });

        signOut.setBackground(new java.awt.Color(88, 101, 242));
        signOut.setFont(new java.awt.Font("SansSerif", 1, 18)); // NOI18N
        signOut.setForeground(new java.awt.Color(255, 255, 255));
        signOut.setIcon(new javax.swing.ImageIcon(getClass().getResource("/icons/icons8_logout_30px.png"))); // NOI18N
        signOut.setText("Sign out");
        signOut.setBorder(javax.swing.BorderFactory.createEmptyBorder(1, 20, 1, 1));
        signOut.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        signOut.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        signOut.setIconTextGap(15);
        signOut.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                signOutActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout menuBarLayout = new javax.swing.GroupLayout(menuBar);
        menuBar.setLayout(menuBarLayout);
        menuBarLayout.setHorizontalGroup(
            menuBarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(account, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(signOut, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(menuBarLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(exit)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(overview, javax.swing.GroupLayout.DEFAULT_SIZE, 240, Short.MAX_VALUE)
            .addComponent(projects, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        menuBarLayout.setVerticalGroup(
            menuBarLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(menuBarLayout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(jLabel12)
                .addGap(49, 49, 49)
                .addComponent(overview, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(projects, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(account, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(208, 208, 208)
                .addComponent(signOut, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 117, Short.MAX_VALUE)
                .addComponent(exit)
                .addContainerGap())
        );

        javax.swing.GroupLayout rootAccountLayout = new javax.swing.GroupLayout(rootAccount);
        rootAccount.setLayout(rootAccountLayout);
        rootAccountLayout.setHorizontalGroup(
            rootAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(rootAccountLayout.createSequentialGroup()
                .addComponent(menuBar, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGroup(rootAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(header, javax.swing.GroupLayout.DEFAULT_SIZE, 870, Short.MAX_VALUE)
                    .addGroup(rootAccountLayout.createSequentialGroup()
                        .addGap(20, 20, 20)
                        .addComponent(bodyAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 834, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 16, Short.MAX_VALUE))))
        );
        rootAccountLayout.setVerticalGroup(
            rootAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(rootAccountLayout.createSequentialGroup()
                .addGroup(rootAccountLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(rootAccountLayout.createSequentialGroup()
                        .addComponent(header, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(bodyAccount, javax.swing.GroupLayout.PREFERRED_SIZE, 569, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(menuBar, javax.swing.GroupLayout.PREFERRED_SIZE, 670, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        getContentPane().add(rootAccount, java.awt.BorderLayout.CENTER);

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    private void minimizeMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_minimizeMouseClicked
        // TODO add your handling code here:
        this.setState(this.ICONIFIED);
    }//GEN-LAST:event_minimizeMouseClicked

    private void jPanel9MouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanel9MouseDragged
        this.setLocation(this.getX() + evt.getX() - this.mouseX, this.getY() + evt.getY() - this.mouseY);
    }//GEN-LAST:event_jPanel9MouseDragged

    private void jPanel9MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanel9MousePressed
        mouseX = evt.getX();
        mouseY = evt.getY();
    }//GEN-LAST:event_jPanel9MousePressed

    private void exitActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_exitActionPerformed
        // TODO add your handling code here:
        dispose();
    }//GEN-LAST:event_exitActionPerformed

    private void projectsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_projectsActionPerformed
        // TODO add your handling code here:
        Project project = new Project();
        project.setVisible(true);
        this.setVisible(false);
    }//GEN-LAST:event_projectsActionPerformed

    private void accountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_accountActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_accountActionPerformed

    private void signOutActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_signOutActionPerformed
        // TODO add your handling code here:
        Login login = new Login();
        login.setVisible(true);
        this.setVisible(false);
    }//GEN-LAST:event_signOutActionPerformed

    private void overviewActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_overviewActionPerformed
        // TODO add your handling code here:
        Home home = new Home();
        home.setVisible(true);
        this.setVisible(false);
    }//GEN-LAST:event_overviewActionPerformed

    private void emailAccountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_emailAccountActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_emailAccountActionPerformed

    private void fNameAccountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_fNameAccountActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_fNameAccountActionPerformed

    private void countryAccountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_countryAccountActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_countryAccountActionPerformed

    private void passAccountActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_passAccountActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_passAccountActionPerformed

    private void modifierActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_modifierActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_modifierActionPerformed

    private void modifierMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_modifierMouseClicked
        // TODO add your handling code here:
        String fName = fNameAccount.getText();
        String email = emailAccount.getText();
        String country = countryAccount.getText();
        String pass = passAccount.getText();
        DataBase data = new DataBase();
        boolean exist = false;
        try {
            data.fillList(data.getUserDb());
        } catch (IOException ex) {
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
        }
        if(fName.isEmpty()){
            jLabelFname.setForeground(Color.red);
        }
        if(email.isEmpty()){
            jLabelEmail.setForeground(Color.red);
        } 
        if(pass.isEmpty()){
             jLabelPass.setForeground(Color.red);
        }
        if (country.isEmpty()){
            jLabelCountry.setForeground(Color.red);
        }
        if(!fName.isEmpty() && !email.isEmpty() && !country.isEmpty() && !pass.isEmpty()){
            for (DataBase u : data.getListOfUser()) {
                if(u.getEmail().equals(email)){
                    jLabelEmail.setForeground(Color.red);
                    exist = true;
                    break;
                }
            }
            
            if (!exist) {
                try {
                    data.addUserToFile(email, fName, country, pass);
                    data.newLine();
                } catch (IOException ex) {
                    Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        data.getListOfUser().clear();
    }//GEN-LAST:event_modifierMouseClicked

    private void modifierMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_modifierMousePressed
        // TODO add your handling code here:
        String fName = fNameAccount.getText();
        String email = emailAccount.getText();
        String country = countryAccount.getText();
        String pass = passAccount.getText();
        DataBase data = new DataBase();
        boolean exist = false;
        try {
            data.fillList(data.getUserDb());
        } catch (IOException ex) {
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
        }
        if(fName.isEmpty()){
            jLabelFname.setForeground(Color.red);
        }
        if(email.isEmpty()){
            jLabelEmail.setForeground(Color.red);
        } 
        if(pass.isEmpty()){
             jLabelPass.setForeground(Color.red);
        }
        if (country.isEmpty()){
            jLabelCountry.setForeground(Color.red);
        }
        if(!fName.isEmpty() && !email.isEmpty() && !country.isEmpty() && !pass.isEmpty()){
            for (DataBase u : data.getListOfUser()) {
                if(u.getEmail().equals(email)){
                    jLabelEmail.setForeground(Color.red);
                    exist = true;
                    break;
                }
            }
            
            if (!exist) {
                try {
                    data.addUserToFile(email, fName, country, pass);
                    data.newLine();
                } catch (IOException ex) {
                    Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        data.getListOfUser().clear();
    }//GEN-LAST:event_modifierMousePressed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton account;
    private projectmanagment.RoundPanel bodyAccount;
    private javax.swing.JTextField countryAccount;
    private javax.swing.JTextField emailAccount;
    private javax.swing.JButton exit;
    private javax.swing.JTextField fNameAccount;
    private javax.swing.JPanel header;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabelCountry;
    private javax.swing.JLabel jLabelEmail;
    private javax.swing.JLabel jLabelFname;
    private javax.swing.JLabel jLabelPass;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JPanel menuBar;
    private javax.swing.JButton minimize;
    private javax.swing.JButton modifier;
    private javax.swing.JButton overview;
    private javax.swing.JTextField passAccount;
    private javax.swing.JButton projects;
    private javax.swing.JPanel rootAccount;
    private javax.swing.JButton signOut;
    // End of variables declaration//GEN-END:variables
}